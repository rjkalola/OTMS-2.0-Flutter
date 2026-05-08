import 'dart:async';

import 'package:belcka/pages/check_in/clock_in/controller/clock_in_utils.dart';
import 'package:belcka/pages/check_in/clock_in/model/counter_details.dart';
import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/location_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_list_response.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/location_service_new.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/app_constants.dart';

class ClockInOfflineController extends GetxController {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isLocationLoaded = false.obs;
  final RxString totalWorkHours = "".obs;
  String? latitude, longitude, location;
  WorkLogListResponse workLogData = WorkLogListResponse();
  Timer? _timer;
  final locationService = LocationServiceNew();

  @override
  void onInit() {
    super.onInit();
    isInternetNotAvailable.value = false;
    _reloadFromStorage();
    LocationInfo? locationInfo = Get.find<AppStorage>().getLastLocation();
    if (locationInfo != null) {
      setLocation(double.parse(locationInfo.latitude ?? "0"),
          double.parse(locationInfo.longitude ?? "0"),
          locationInput: locationInfo.location);
    }
    locationRequest();
    appLifeCycle();
    _refreshCounterFromData();
    if (workLogData.userIsWorking == true || _hasAnyRunningSession()) {
      startTimer();
    }
    print("----------------------------------------------");
    print("hasOfflineRecordsForUpload:"+hasOfflineRecordsForUpload().toString());
    print("----------------------------------------------");
    getOfflineRecordsUploadJson();
  }

  /// Called each time screen opens/re-opens.
  void onScreenEnter() {
    _reloadFromStorage();
    _refreshCounterFromData();
    if (workLogData.userIsWorking == true || _hasAnyRunningSession()) {
      startTimer();
    } else {
      stopTimer();
    }
  }

  @override
  void onClose() {
    stopTimer();
    super.onClose();
  }

  void _reloadFromStorage() {
    workLogData = Get.find<AppStorage>().getWorklogDataOffline();
    workLogData.workLogInfo ??= <WorkLogInfo>[];
    print("Size"+workLogData.workLogInfo!.length.toString());
  }

  void _persist() {
    Get.find<AppStorage>().setWorklogDataOffline(workLogData);
  }

  bool _isOfflineUploadCandidate(WorkLogInfo log) {
    final int id = log.id ?? 0;
    final bool createdOffline = id == 0;
    final bool stoppedOffline = id > 0 && (log.offlineRecord ?? false);
    if (!createdOffline && !stoppedOffline) return false;

    if (createdOffline) {
      return !StringHelper.isEmptyString(log.workStartTime);
    }

    return !StringHelper.isEmptyString(log.workStartTime) &&
        !StringHelper.isEmptyString(log.workEndTime);
  }

  bool hasOfflineRecordsForUpload() {
    _reloadFromStorage();
    for (final log in workLogData.workLogInfo ?? <WorkLogInfo>[]) {
      if (_isOfflineUploadCandidate(log)) return true;
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> getOfflineRecordsUploadJson() async {
    _reloadFromStorage();
    final List<Map<String, dynamic>> rows = [];
    for (final log in workLogData.workLogInfo ?? <WorkLogInfo>[]) {
      if (!_isOfflineUploadCandidate(log)) continue;

      final Map<String, dynamic> row = {
        "work_start_time": log.workStartTime,
        "work_end_time": log.workEndTime,
        "start_work_location": log.startWorkLocation?.toJson(),
        "stop_work_location": log.stopWorkLocation?.toJson(),
      };
      if ((log.id ?? 0) > 0) {
        row["user_worklog_id"] = log.id;
        row["shift_id"] = log.shiftId;
        if (log.projectId != null) {
          row["project_id"] = log.projectId;
        }
      }
      rows.add(row);
    }
    print("----------------------------------");
    StringHelper.printLongString(rows.toString());
    print("----------------------------------");

    return rows;
  }

  /// Final request payload for offline upload.
  /// For `id > 0` rows, includes: `user_worklog_id`, `shift_id`, `project_id`.
  /// For `id == 0` rows, shift/project are intentionally omitted (selected later).
  Future<Map<String, dynamic>> getOfflineUploadRequestBody() async {
    final List<Map<String, dynamic>> worklogs = await getOfflineRecordsUploadJson();
    final int userId = Get.find<AppStorage>().getUserInfo().id ?? 0;
    final String deviceModelName = await AppUtils.getDeviceName();
    return {
      "user_id": userId,
      "device_type": AppConstants.deviceType,
      "device_model_type": deviceModelName,
      "worklogs": worklogs,
    };
  }

  int? get _effectiveShiftId =>
      workLogData.shiftInfo?.id ?? workLogData.shiftId;

  bool _logMatchesDayShift(WorkLogInfo l) {
    final int? sid = l.shiftId;
    if (sid == null) return false;
    final int? eff = _effectiveShiftId;
    if (eff != null) return eff == sid;
    if (workLogData.shiftId != null) return workLogData.shiftId == sid;
    return true;
  }

  /// Calendar day `dd/MM/yyyy` for shift math (API day or first segment date).
  String _calendarDayForCalcs(WorkLogListResponse logs) {
    if (!StringHelper.isEmptyString(logs.workStartDate)) {
      return logs.workStartDate!;
    }
    for (final l in logs.workLogInfo ?? <WorkLogInfo>[]) {
      final ws = l.workStartTime?.trim();
      if (StringHelper.isEmptyString(ws)) continue;
      final sp = ws!.indexOf(' ');
      if (sp > 0) return ws.substring(0, sp);
    }
    return '';
  }

  bool _isOpenRunning(WorkLogInfo l) {
    if (StringHelper.isEmptyString(l.workStartTime)) return false;
    if (!StringHelper.isEmptyString(l.workEndTime)) return false;
    final int id = l.id ?? 0;
    if (id == 0) return true;
    if (id > 0 && (l.offlineRecord ?? false)) return false;
    return _logMatchesDayShift(l);
  }

  bool _hasAnyRunningSession() {
    for (final l in workLogData.workLogInfo ?? <WorkLogInfo>[]) {
      if (_isOpenRunning(l)) return true;
    }
    return false;
  }

  WorkLogInfo? _runningOnlineLog() {
    for (final l in workLogData.workLogInfo ?? <WorkLogInfo>[]) {
      if ((l.id ?? 0) > 0 &&
          _logMatchesDayShift(l) &&
          StringHelper.isEmptyString(l.workEndTime) &&
          !(l.offlineRecord ?? false)) {
        return l;
      }
    }
    return null;
  }

  WorkLogInfo? _runningOfflineOnlyLog() {
    for (final l in workLogData.workLogInfo ?? <WorkLogInfo>[]) {
      if ((l.id ?? 0) == 0 &&
          !StringHelper.isEmptyString(l.workStartTime) &&
          StringHelper.isEmptyString(l.workEndTime)) {
        return l;
      }
    }
    return null;
  }

  void _recomputeUserWorkingAndTotals() {
    final bool any = _hasAnyRunningSession();
    workLogData.userIsWorking = any;
    if (!any) {
      int sum = 0;
      for (final l in workLogData.workLogInfo ?? <WorkLogInfo>[]) {
        if ((l.id ?? 0) == 0) {
          if (!StringHelper.isEmptyString(l.workEndTime)) {
            sum += l.payableWorkSeconds ?? 0;
          }
        } else if (_logMatchesDayShift(l)) {
          if (!StringHelper.isEmptyString(l.workEndTime) ||
              (l.offlineRecord ?? false)) {
            sum += l.payableWorkSeconds ?? 0;
          }
        }
      }
      workLogData.totalPayableWorkingSeconds = sum;
    }
  }

  LocationInfo? _currentLocationInfo() {
    if (StringHelper.isEmptyString(latitude) ||
        StringHelper.isEmptyString(longitude)) {
      return null;
    }
    return LocationInfo(
      latitude: latitude,
      longitude: longitude,
      location: location,
    );
  }

  String _nowWorkDateTimeString() {
    return DateUtil.dateToString(
        DateTime.now(), DateUtil.DD_MM_YYYY_TIME_24_SLASH2);
  }

  /// Stop online-running row first if present; otherwise stop offline id==0 row.
  Future<void> onStopWork() async {
    print("111");
    // await fetchLocationAndAddress();
    print("2222");
    final DateTime sessionEnd = DateTime.now();
    final String endStr = _nowWorkDateTimeString();
    final LocationInfo? stopLoc = _currentLocationInfo();

    final WorkLogInfo? online = _runningOnlineLog();
    if (online != null) {
      // Preserve identifiers for server upload of offline-stopped online rows.
      online.shiftId ??= workLogData.shiftId ?? workLogData.shiftInfo?.id;
      online.projectId ??= workLogData.projectId;
      final calc = _calculateOnlineLogPayableAt(
        workLogData,
        online,
        sessionEnd,
      );
      online.workEndTime = endStr;
      online.stopWorkLocation = stopLoc;
      online.payableWorkSeconds = calc.payableWorkSeconds;
      online.totalBreaklogSeconds = calc.breakSeconds;
      try {
        final DateFormat fullFormat =
            DateFormat(DateUtil.DD_MM_YYYY_TIME_24_SLASH2);
        final ws = fullFormat.parse(online.workStartTime!);
        online.totalWorkSeconds =
            sessionEnd.difference(ws).inSeconds.clamp(0, 1 << 30).toInt();
      } catch (_) {
        online.totalWorkSeconds = calc.payableWorkSeconds + calc.breakSeconds;
      }
      online.offlineRecord = true;
    } else {
      final WorkLogInfo? off = _runningOfflineOnlyLog();
      if (off == null) return;
      try {
        final DateFormat fullFormat =
            DateFormat(DateUtil.DD_MM_YYYY_TIME_24_SLASH2);
        final ws = fullFormat.parse(off.workStartTime!);
        final int secs =
            DateUtil.dateDifferenceInSeconds(date1: ws, date2: sessionEnd)
                .clamp(0, 1 << 30)
                .toInt();
        off.workEndTime = endStr;
        off.stopWorkLocation = stopLoc;
        off.payableWorkSeconds = secs;
        off.totalWorkSeconds = secs;
        off.totalBreaklogSeconds = 0;
      } catch (_) {}
    }

    _recomputeUserWorkingAndTotals();
    _persist();
    _refreshCounterFromData();
    if (!_hasAnyRunningSession()) {
      stopTimer();
    }
  }

  /// Start a new offline-only segment ([id] == 0) when no session is running.
  Future<void> onStartWork() async {
    if (_hasAnyRunningSession()) return;
    // await fetchLocationAndAddress();
    final LocationInfo? startLoc = _currentLocationInfo();
    final String startStr = _nowWorkDateTimeString();

    WorkLogInfo? slot;
    for (final l in workLogData.workLogInfo ?? <WorkLogInfo>[]) {
      if ((l.id ?? 0) == 0 && StringHelper.isEmptyString(l.workStartTime)) {
        slot = l;
        break;
      }
    }
    if (slot != null) {
      slot.workStartTime = startStr;
      slot.startWorkLocation = startLoc;
      slot.shiftId = workLogData.shiftId;
      slot.shiftName = workLogData.shiftName;
      slot.projectId = workLogData.projectId;
      slot.projectName = workLogData.projectName;
      slot.isPricework = false;
    } else {
      workLogData.workLogInfo!.add(WorkLogInfo(
        id: 0,
        shiftId: workLogData.shiftId,
        shiftName: workLogData.shiftName,
        projectId: workLogData.projectId,
        projectName: workLogData.projectName,
        isPricework: false,
        workStartTime: startStr,
        startWorkLocation: startLoc,
      ));
    }

    workLogData.userIsWorking = true;
    _persist();
    startTimer();
    _refreshCounterFromData();
  }

  bool get showStopButton => _hasAnyRunningSession();

  /// Treat null [isCheckIn] as true so offline start is available if the flag
  /// was lost in storage round-trip.
  bool get showStartButton =>
      !showStopButton && (workLogData.isCheckIn != false);

  void startTimer() {
    stopTimer();
    _onTick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isClosed) return;
      try {
        _onTick();
      } catch (_) {
        // Keep periodic timer alive even if one tick fails.
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _onTick() {
    // Do not reload from disk every tick — it resets in-memory state and can
    // drop nested maps / types from GetStorage reads.
    _refreshCounterFromData();
  }

  void _refreshCounterFromData() {
    final CounterDetails details = _getTotalWorkHoursOffline(workLogData);
    if (totalWorkHours.value == details.totalWorkTime) {
      totalWorkHours.refresh();
    } else {
      totalWorkHours.value = details.totalWorkTime;
    }
  }

  CounterDetails _zeroCounterDetails() {
    return CounterDetails(
        totalWorkSeconds: 0,
        activeWorkSeconds: 0,
        totalWorkTime: DateUtil.seconds_To_HH_MM_SS(0),
        remainingBreakTime: DateUtil.seconds_To_HH_MM_SS(0),
        remainingLeaveTime: DateUtil.seconds_To_HH_MM_SS(0),
        remainingBreakSeconds: 0,
        isOnBreak: false,
        insideShiftTime: false,
        isOnLeave: false,
        remainingLeaveSeconds: 0);
  }

  /// When [shift_info] is missing from storage, use wall-clock from work start.
  CounterDetails _fallbackTotalWhileWorking(WorkLogListResponse logs) {
    int totalWorkHourSeconds = 0;
    final DateFormat fullFormat =
        DateFormat(DateUtil.DD_MM_YYYY_TIME_24_SLASH2);
    final DateTime now = DateTime.now();

    for (var log in logs.workLogInfo ?? <WorkLogInfo>[]) {
      if ((log.id ?? 0) != 0) continue;
      if (StringHelper.isEmptyString(log.workStartTime)) continue;
      if (!StringHelper.isEmptyString(log.workEndTime)) {
        totalWorkHourSeconds += (log.payableWorkSeconds ?? 0);
      } else {
        try {
          final DateTime ws = fullFormat.parse(log.workStartTime!);
          int secs = DateUtil.dateDifferenceInSeconds(date1: ws, date2: now);
          if (secs > 0) totalWorkHourSeconds += secs;
        } catch (_) {}
      }
    }
    for (var log in logs.workLogInfo ?? <WorkLogInfo>[]) {
      if ((log.id ?? 0) == 0) continue;
      if (!_logMatchesDayShift(log)) continue;
      if (!StringHelper.isEmptyString(log.workEndTime)) {
        totalWorkHourSeconds += (log.payableWorkSeconds ?? 0);
        continue;
      }
      if (log.offlineRecord == true) {
        totalWorkHourSeconds += (log.payableWorkSeconds ?? 0);
        continue;
      }
      try {
        final DateTime ws = fullFormat.parse(log.workStartTime!);
        int secs = DateUtil.dateDifferenceInSeconds(date1: ws, date2: now);
        if (secs > 0) totalWorkHourSeconds += secs;
      } catch (_) {}
    }

    return CounterDetails(
        totalWorkSeconds: totalWorkHourSeconds,
        activeWorkSeconds: 0,
        totalWorkTime: DateUtil.seconds_To_HH_MM_SS(totalWorkHourSeconds),
        remainingBreakTime: DateUtil.seconds_To_HH_MM_SS(0),
        remainingLeaveTime: DateUtil.seconds_To_HH_MM_SS(0),
        remainingBreakSeconds: 0,
        isOnBreak: false,
        insideShiftTime: true,
        isOnLeave: false,
        remainingLeaveSeconds: 0);
  }

  /// Same shift / leave / break rules as [ClockInUtils.getTotalWorkHours], plus
  /// offline `id == 0` segments and `offlineRecord` online rows — kept here so
  /// [ClockInUtils] stays unchanged.
  CounterDetails _getTotalWorkHoursOffline(WorkLogListResponse? logs) {
    int totalWorkHourSeconds = 0,
        activeWorkSeconds = 0,
        remainingBreakSeconds = 0,
        remainingLeaveSeconds = 0;
    bool isOnBreak = false, insideShiftTime = false, isOnLeave = false;

    if (logs != null) {
      if (!(logs.userIsWorking ?? false)) {
        totalWorkHourSeconds = logs.totalPayableWorkingSeconds ?? 0;
      } else {
        final String calendarDay = _calendarDayForCalcs(logs);
        if (StringHelper.isEmptyString(calendarDay)) {
          return _zeroCounterDetails();
        }

        if (logs.shiftInfo == null ||
            StringHelper.isEmptyString(logs.shiftInfo!.startTime) ||
            StringHelper.isEmptyString(logs.shiftInfo!.endTime)) {
          return _fallbackTotalWhileWorking(logs);
        }

        DateTime currentDateTime = DateTime.now();
        final DateFormat fullFormat =
            DateFormat(DateUtil.DD_MM_YYYY_TIME_24_SLASH2);

        String todayDate = "";
        if (ClockInUtils.isCurrentDay(calendarDay)) {
          todayDate =
              DateUtil.dateToString(DateTime.now(), DateUtil.DD_MM_YYYY_SLASH);
        } else {
          todayDate = calendarDay;
        }

        if (ClockInUtils.isCurrentDay(calendarDay)) {
          currentDateTime = DateTime.now();
        } else {
          currentDateTime = fullFormat.parse(
              "$todayDate ${DateUtil.changeDateFormat(logs.shiftInfo?.endTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");
        }

        final DateTime shiftStartTime = fullFormat.parse(
            "$todayDate ${DateUtil.changeDateFormat(logs.shiftInfo?.startTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

        final DateTime shiftEndTime = fullFormat.parse(
            "$todayDate ${DateUtil.changeDateFormat(logs.shiftInfo?.endTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

        int overlapSeconds(
            DateTime aStart, DateTime aEnd, DateTime bStart, DateTime bEnd) {
          final start = aStart.isAfter(bStart) ? aStart : bStart;
          final end = aEnd.isBefore(bEnd) ? aEnd : bEnd;
          if (end.isBefore(start)) return 0;
          return end.difference(start).inSeconds;
        }

        for (var log in logs.workLogInfo ?? <WorkLogInfo>[]) {
          if ((log.id ?? 0) != 0) continue;
          if (StringHelper.isEmptyString(log.workStartTime)) continue;
          if (!StringHelper.isEmptyString(log.workEndTime)) {
            totalWorkHourSeconds += (log.payableWorkSeconds ?? 0);
          } else {
            try {
              final DateTime ws = fullFormat.parse(log.workStartTime!);
              int secs = DateUtil.dateDifferenceInSeconds(
                  date1: ws, date2: currentDateTime);
              if (secs > 0) totalWorkHourSeconds += secs;
            } catch (_) {}
          }
        }

        bool isFullDayLeaveAvailable =
            ClockInUtils.hasFullDayLeave(logs.userLeaves);
        if (!isFullDayLeaveAvailable) {
          for (var log in logs.workLogInfo ?? <WorkLogInfo>[]) {
            if ((log.id ?? 0) == 0) continue;
            if (!_logMatchesDayShift(log)) continue;

            DateTime workStartTime;
            DateTime workEndTime;

            final String workStart = log.workStartTime ?? "";
            final String workEnd = log.workEndTime ?? "";

            if (!StringHelper.isEmptyString(workEnd)) {
              totalWorkHourSeconds += (log.payableWorkSeconds ?? 0);
              continue;
            }

            if (log.offlineRecord == true) {
              totalWorkHourSeconds += (log.payableWorkSeconds ?? 0);
              continue;
            }

            final DateTime parsedWorkStart = fullFormat.parse(workStart);
            if (parsedWorkStart.isBefore(shiftStartTime)) {
              workStartTime = shiftStartTime;
            } else if (parsedWorkStart.isAfter(shiftEndTime)) {
              workStartTime = shiftEndTime;
            } else {
              workStartTime = parsedWorkStart;
            }

            if (currentDateTime.isBefore(shiftStartTime)) {
              workEndTime = shiftStartTime;
            } else if (currentDateTime.isAfter(shiftEndTime)) {
              workEndTime = shiftEndTime;
            } else {
              workEndTime = currentDateTime;
              insideShiftTime = true;
            }

            activeWorkSeconds = DateUtil.dateDifferenceInSeconds(
                date1: workStartTime, date2: workEndTime);

            if (activeWorkSeconds <= 0) continue;

            int totalLeaveSeconds = 0;

            for (var leave in logs.userLeaves ?? <LeaveInfo>[]) {
              if (leave.isAlldayLeave == true) continue;

              final DateTime leaveStart = fullFormat.parse(
                  "$todayDate ${DateUtil.changeDateFormat(leave.startTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

              final DateTime leaveEnd = fullFormat.parse(
                  "$todayDate ${DateUtil.changeDateFormat(leave.endTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

              if (currentDateTime.isAfter(leaveStart) &&
                  currentDateTime.isBefore(leaveEnd)) {
                isOnLeave = true;
              }

              totalLeaveSeconds += overlapSeconds(
                  workStartTime, workEndTime, leaveStart, leaveEnd);
            }

            activeWorkSeconds -= totalLeaveSeconds;
            if (activeWorkSeconds < 0) activeWorkSeconds = 0;

            if (isOnLeave) {
              isOnBreak = false;
              remainingBreakSeconds = 0;
            }

            for (var breakInfo in logs.shiftInfo?.breaks ?? []) {
              if (StringHelper.isEmptyString(breakInfo.breakStartTime) ||
                  StringHelper.isEmptyString(breakInfo.breakEndTime)) continue;

              final DateTime breakStartTime = fullFormat.parse(
                  "$todayDate ${DateUtil.changeDateFormat(breakInfo.breakStartTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

              final DateTime breakEndTime = fullFormat.parse(
                  "$todayDate ${DateUtil.changeDateFormat(breakInfo.breakEndTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

              if (breakEndTime.isBefore(workStartTime) ||
                  breakStartTime.isAfter(workEndTime)) continue;

              if (!isOnLeave &&
                  currentDateTime.isAfter(breakStartTime) &&
                  currentDateTime.isBefore(breakEndTime)) {
                isOnBreak = true;
                remainingBreakSeconds =
                    breakEndTime.difference(currentDateTime).inSeconds;
              }

              final DateTime actualStart =
                  breakStartTime.isBefore(workStartTime)
                      ? workStartTime
                      : breakStartTime;

              final DateTime actualEnd = breakEndTime.isAfter(workEndTime)
                  ? workEndTime
                  : breakEndTime;

              int breakSeconds = actualEnd.difference(actualStart).inSeconds;

              for (var leave in logs.userLeaves ?? <LeaveInfo>[]) {
                if (leave.isAlldayLeave == true) continue;

                final DateTime leaveStart = fullFormat.parse(
                    "$todayDate ${DateUtil.changeDateFormat(leave.startTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

                final DateTime leaveEnd = fullFormat.parse(
                    "$todayDate ${DateUtil.changeDateFormat(leave.endTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

                breakSeconds -= overlapSeconds(
                    actualStart, actualEnd, leaveStart, leaveEnd);
              }

              if (breakSeconds < 0) breakSeconds = 0;

              activeWorkSeconds -= breakSeconds;
            }

            if (activeWorkSeconds < 0) activeWorkSeconds = 0;

            totalWorkHourSeconds += activeWorkSeconds;
          }
        } else {
          isOnLeave = true;
        }
      }
    }

    return CounterDetails(
        totalWorkSeconds: totalWorkHourSeconds,
        activeWorkSeconds: activeWorkSeconds,
        totalWorkTime: DateUtil.seconds_To_HH_MM_SS(totalWorkHourSeconds),
        remainingBreakTime: DateUtil.seconds_To_HH_MM_SS(remainingBreakSeconds),
        remainingLeaveTime: DateUtil.seconds_To_HH_MM_SS(remainingLeaveSeconds),
        remainingBreakSeconds: remainingBreakSeconds,
        isOnBreak: isOnBreak,
        insideShiftTime: insideShiftTime,
        isOnLeave: isOnLeave,
        remainingLeaveSeconds: remainingLeaveSeconds);
  }

  ({int payableWorkSeconds, int breakSeconds}) _wallPayableOnline(
    WorkLogInfo log,
    DateTime sessionEnd,
  ) {
    if (StringHelper.isEmptyString(log.workStartTime)) {
      return (payableWorkSeconds: 0, breakSeconds: 0);
    }
    try {
      final DateFormat fullFormat =
          DateFormat(DateUtil.DD_MM_YYYY_TIME_24_SLASH2);
      final DateTime ws = fullFormat.parse(log.workStartTime!);
      int s = sessionEnd.difference(ws).inSeconds;
      if (s < 0) s = 0;
      return (payableWorkSeconds: s, breakSeconds: 0);
    } catch (_) {
      return (payableWorkSeconds: 0, breakSeconds: 0);
    }
  }

  /// Payable and break seconds for an online worklog through [sessionEnd]
  /// (same rules as the running-online branch in [ClockInUtils.getTotalWorkHours]).
  ({int payableWorkSeconds, int breakSeconds}) _calculateOnlineLogPayableAt(
    WorkLogListResponse logs,
    WorkLogInfo log,
    DateTime sessionEnd,
  ) {
    if (logs.workLogInfo == null) {
      return (payableWorkSeconds: 0, breakSeconds: 0);
    }
    final String calendarDay = _calendarDayForCalcs(logs);
    if (StringHelper.isEmptyString(calendarDay)) {
      return (payableWorkSeconds: 0, breakSeconds: 0);
    }
    if ((log.id ?? 0) == 0 || !_logMatchesDayShift(log)) {
      return (payableWorkSeconds: 0, breakSeconds: 0);
    }
    if (ClockInUtils.hasFullDayLeave(logs.userLeaves)) {
      return (payableWorkSeconds: 0, breakSeconds: 0);
    }

    if (logs.shiftInfo == null ||
        StringHelper.isEmptyString(logs.shiftInfo!.startTime) ||
        StringHelper.isEmptyString(logs.shiftInfo!.endTime)) {
      return _wallPayableOnline(log, sessionEnd);
    }

    final DateFormat fullFormat =
        DateFormat(DateUtil.DD_MM_YYYY_TIME_24_SLASH2);

    String todayDate = "";
    if (ClockInUtils.isCurrentDay(calendarDay)) {
      todayDate =
          DateUtil.dateToString(DateTime.now(), DateUtil.DD_MM_YYYY_SLASH);
    } else {
      todayDate = calendarDay;
    }

    DateTime currentDateTime;
    if (ClockInUtils.isCurrentDay(calendarDay)) {
      currentDateTime = sessionEnd;
    } else {
      currentDateTime = fullFormat.parse(
          "$todayDate ${DateUtil.changeDateFormat(logs.shiftInfo?.endTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");
    }

    final DateTime shiftStartTime = fullFormat.parse(
        "$todayDate ${DateUtil.changeDateFormat(logs.shiftInfo?.startTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

    final DateTime shiftEndTime = fullFormat.parse(
        "$todayDate ${DateUtil.changeDateFormat(logs.shiftInfo?.endTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

    int overlapSeconds(
        DateTime aStart, DateTime aEnd, DateTime bStart, DateTime bEnd) {
      final start = aStart.isAfter(bStart) ? aStart : bStart;
      final end = aEnd.isBefore(bEnd) ? aEnd : bEnd;
      if (end.isBefore(start)) return 0;
      return end.difference(start).inSeconds;
    }

    final String workStart = log.workStartTime ?? "";
    if (StringHelper.isEmptyString(workStart)) {
      return (payableWorkSeconds: 0, breakSeconds: 0);
    }

    DateTime workStartTime;
    DateTime workEndTime;

    final DateTime parsedWorkStart = fullFormat.parse(workStart);
    if (parsedWorkStart.isBefore(shiftStartTime)) {
      workStartTime = shiftStartTime;
    } else if (parsedWorkStart.isAfter(shiftEndTime)) {
      workStartTime = shiftEndTime;
    } else {
      workStartTime = parsedWorkStart;
    }

    if (currentDateTime.isBefore(shiftStartTime)) {
      workEndTime = shiftStartTime;
    } else if (currentDateTime.isAfter(shiftEndTime)) {
      workEndTime = shiftEndTime;
    } else {
      workEndTime = currentDateTime;
    }

    int activeWorkSeconds = DateUtil.dateDifferenceInSeconds(
        date1: workStartTime, date2: workEndTime);

    if (activeWorkSeconds <= 0) {
      return (payableWorkSeconds: 0, breakSeconds: 0);
    }

    int totalLeaveSeconds = 0;
    for (var leave in logs.userLeaves ?? <LeaveInfo>[]) {
      if (leave.isAlldayLeave == true) continue;
      final DateTime leaveStart = fullFormat.parse(
          "$todayDate ${DateUtil.changeDateFormat(leave.startTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");
      final DateTime leaveEnd = fullFormat.parse(
          "$todayDate ${DateUtil.changeDateFormat(leave.endTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");
      totalLeaveSeconds +=
          overlapSeconds(workStartTime, workEndTime, leaveStart, leaveEnd);
    }

    activeWorkSeconds -= totalLeaveSeconds;
    if (activeWorkSeconds < 0) activeWorkSeconds = 0;

    int totalBreakHourSeconds = 0;
    for (var breakInfo in logs.shiftInfo?.breaks ?? []) {
      if (StringHelper.isEmptyString(breakInfo.breakStartTime) ||
          StringHelper.isEmptyString(breakInfo.breakEndTime)) continue;

      final DateTime breakStartTime = fullFormat.parse(
          "$todayDate ${DateUtil.changeDateFormat(breakInfo.breakStartTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

      final DateTime breakEndTime = fullFormat.parse(
          "$todayDate ${DateUtil.changeDateFormat(breakInfo.breakEndTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

      if (breakEndTime.isBefore(workStartTime) ||
          breakStartTime.isAfter(workEndTime)) continue;

      final DateTime actualStart = breakStartTime.isBefore(workStartTime)
          ? workStartTime
          : breakStartTime;

      final DateTime actualEnd =
          breakEndTime.isAfter(workEndTime) ? workEndTime : breakEndTime;

      int breakSeconds = actualEnd.difference(actualStart).inSeconds;

      for (var leave in logs.userLeaves ?? <LeaveInfo>[]) {
        if (leave.isAlldayLeave == true) continue;
        final DateTime leaveStart = fullFormat.parse(
            "$todayDate ${DateUtil.changeDateFormat(leave.startTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");
        final DateTime leaveEnd = fullFormat.parse(
            "$todayDate ${DateUtil.changeDateFormat(leave.endTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");
        breakSeconds -=
            overlapSeconds(actualStart, actualEnd, leaveStart, leaveEnd);
      }

      if (breakSeconds < 0) breakSeconds = 0;

      totalBreakHourSeconds += breakSeconds;
      activeWorkSeconds -= breakSeconds;
    }

    if (activeWorkSeconds < 0) activeWorkSeconds = 0;

    return (
      payableWorkSeconds: activeWorkSeconds,
      breakSeconds: totalBreakHourSeconds
    );
  }

  void appLifeCycle() {
    AppLifecycleListener(
      onResume: () async {
        if (!isLocationLoaded.value) locationRequest();
        _reloadFromStorage();
        _refreshCounterFromData();
        if (workLogData.userIsWorking == true || _hasAnyRunningSession()) {
          startTimer();
        }
      },
      onPause: () {
        stopTimer();
      },
    );
  }

  Future<void> locationRequest() async {
    bool ok = await locationService.checkLocationService();
    if (ok) {
      fetchLocationAndAddress();
    }
  }

  Future<void> fetchLocationAndAddress() async {
    Position? latLon = await LocationServiceNew.getCurrentLocation();
    if (latLon != null) {
      isLocationLoaded.value = true;
      setLocation(latLon.latitude, latLon.longitude);
    }
  }

  Future<void> setLocation(double? lat, double? lon,
      {String? locationInput}) async {
    if (lat != null && lon != null) {
      latitude = lat.toString();
      longitude = lon.toString();
      print("setLocation");
      if (!StringHelper.isEmptyString(locationInput)) {
        print("locationInput:" + locationInput!);
        location = locationInput;
        // location = await LocationServiceNew.getAddressFromCoordinates(lat, lon);
      }
    }
  }

  void onBackPress() {
    Get.offAllNamed(AppRoutes.dashboardScreen);
  }
}
