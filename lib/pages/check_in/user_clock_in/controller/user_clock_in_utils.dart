import 'package:belcka/pages/check_in/clock_in/model/counter_details.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_list_response.dart';
import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// class UserClockInUtils {
//   static CounterDetails getTotalWorkHours(WorkLogListResponse? logs) {
//     int totalWorkHourSeconds = 0;
//     int activeWorkSeconds = 0;
//     int totalBreakHourSeconds = 0;
//     int remainingBreakSeconds = 0;
//
//     bool isOnBreak = false;
//     bool insideShiftTime = false;
//
//     if (logs == null ||
//         logs.workLogInfo == null ||
//         logs.shiftInfo == null ||
//         StringHelper.isEmptyString(logs.workStartDate)) {
//       return _emptyCounter();
//     }
//
//     final DateFormat fullFormat =
//         DateFormat(DateUtil.DD_MM_YYYY_TIME_24_SLASH2);
//
//     final String workDay = logs.workStartDate!;
//
//     if (StringHelper.isEmptyString(logs.shiftInfo!.startTime) ||
//         StringHelper.isEmptyString(logs.shiftInfo!.endTime)) {
//       return _emptyCounter();
//     }
//
//     final String shiftStart =
//         "$workDay ${DateUtil.changeDateFormat(logs.shiftInfo!.startTime!, DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";
//
//     final String shiftEnd =
//         "$workDay ${DateUtil.changeDateFormat(logs.shiftInfo!.endTime!, DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";
//
//     DateTime shiftStartTime = fullFormat.parse(shiftStart);
//     DateTime shiftEndTime = fullFormat.parse(shiftEnd);
//
//     if (shiftEndTime.isBefore(shiftStartTime)) {
//       shiftEndTime = shiftEndTime.add(const Duration(days: 1));
//     }
//
//     DateTime now = DateTime.now();
//     DateTime effectiveCurrentTime;
//
//     if (now.isAfter(shiftEndTime)) {
//       effectiveCurrentTime = shiftEndTime;
//       insideShiftTime = false;
//     } else if (now.isBefore(shiftStartTime)) {
//       effectiveCurrentTime = shiftStartTime;
//       insideShiftTime = false;
//     } else {
//       effectiveCurrentTime = now;
//       insideShiftTime = true;
//     }
//
//     for (var log in logs.workLogInfo!) {
//       if ((log.id ?? 0) == 0 || logs.shiftInfo!.id != log.shiftId) continue;
//
//       if (StringHelper.isEmptyString(log.workStartTime)) continue;
//
//       DateTime workStartTime = fullFormat.parse(log.workStartTime!);
//
//       if (workStartTime.isBefore(shiftStartTime)) {
//         workStartTime = shiftStartTime;
//       }
//
//       if (!StringHelper.isEmptyString(log.workEndTime)) {
//         DateTime workEndTime = fullFormat.parse(log.workEndTime!);
//
//         if (workEndTime.isAfter(shiftEndTime)) {
//           workEndTime = shiftEndTime;
//         }
//
//         totalWorkHourSeconds += log.payableWorkSeconds ?? 0;
//         totalBreakHourSeconds += log.totalBreaklogSeconds ?? 0;
//         continue;
//       }
//
//       DateTime workEndTime = effectiveCurrentTime;
//
//       int runningSeconds = DateUtil.dateDifferenceInSeconds(
//         date1: workStartTime,
//         date2: workEndTime,
//       );
//
//       if (logs.shiftInfo!.breaks != null) {
//         for (var breakInfo in logs.shiftInfo!.breaks!) {
//           if (StringHelper.isEmptyString(breakInfo.breakStartTime) ||
//               StringHelper.isEmptyString(breakInfo.breakEndTime)) continue;
//
//           final String breakStart =
//               "$workDay ${DateUtil.changeDateFormat(breakInfo.breakStartTime!, DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";
//
//           final String breakEnd =
//               "$workDay ${DateUtil.changeDateFormat(breakInfo.breakEndTime!, DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";
//
//           DateTime breakStartTime = fullFormat.parse(breakStart);
//           DateTime breakEndTime = fullFormat.parse(breakEnd);
//
//           if (breakEndTime.isBefore(breakStartTime)) {
//             breakEndTime = breakEndTime.add(const Duration(days: 1));
//           }
//
//           if (breakEndTime.isBefore(workStartTime) ||
//               breakStartTime.isAfter(workEndTime)) continue;
//
//           final DateTime actualStart = breakStartTime.isBefore(workStartTime)
//               ? workStartTime
//               : breakStartTime;
//           final DateTime actualEnd =
//               breakEndTime.isAfter(workEndTime) ? workEndTime : breakEndTime;
//
//           final int breakSeconds = actualEnd.difference(actualStart).inSeconds;
//
//           runningSeconds -= breakSeconds;
//           totalBreakHourSeconds += breakSeconds;
//
//           if (!effectiveCurrentTime.isBefore(breakStartTime) &&
//               effectiveCurrentTime.isBefore(breakEndTime)) {
//             remainingBreakSeconds =
//                 breakEndTime.difference(effectiveCurrentTime).inSeconds;
//             isOnBreak = true;
//           }
//         }
//       }
//
//       activeWorkSeconds += runningSeconds;
//       totalWorkHourSeconds += runningSeconds;
//     }
//
//     return CounterDetails(
//       totalWorkSeconds: totalWorkHourSeconds,
//       activeWorkSeconds: activeWorkSeconds,
//       totalWorkTime: DateUtil.seconds_To_HH_MM_SS(totalWorkHourSeconds),
//       remainingBreakTime: DateUtil.seconds_To_HH_MM_SS(remainingBreakSeconds),
//       remainingBreakSeconds: remainingBreakSeconds,
//       isOnBreak: isOnBreak,
//       insideShiftTime: insideShiftTime,
//     );
//   }
//
//   static CounterDetails _emptyCounter() {
//     return CounterDetails(
//       totalWorkSeconds: 0,
//       activeWorkSeconds: 0,
//       totalWorkTime: DateUtil.seconds_To_HH_MM_SS(0),
//       remainingBreakTime: DateUtil.seconds_To_HH_MM_SS(0),
//       remainingBreakSeconds: 0,
//       isOnBreak: false,
//       insideShiftTime: false,
//     );
//   }
//
//   static bool isCurrentDay(String inputDate) {
//     DateTime? inputDateTime =
//         DateUtil.stringToDate(inputDate, DateUtil.DD_MM_YYYY_SLASH);
//     DateTime today = DateTime.now();
//     return inputDateTime?.year == today.year &&
//         inputDateTime?.month == today.month &&
//         inputDateTime?.day == today.day;
//   }
// }

class UserClockInUtils {
  static CounterDetails getTotalWorkHours(WorkLogListResponse? logs) {
    int totalWorkHourSeconds = 0,
        activeWorkSeconds = 0,
        totalBreakHourSeconds = 0,
        remainingBreakSeconds = 0,
        remainingLeaveSeconds = 0,
        totalLeaveSeconds = 0;
    bool isOnBreak = false, insideShiftTime = false, isOnLeave = false;

    if (logs != null) {
      if (!(logs.userIsWorking ?? false)) {
        totalWorkHourSeconds = logs.totalPayableWorkingSeconds ?? 0;
        isOnLeave = isUserOnAllDayLeaveToday(logs);
      } else {
        /* DateTime currentDateTime = DateTime.now();
        final DateFormat fullFormat =
            DateFormat(DateUtil.DD_MM_YYYY_TIME_24_SLASH2);

        String todayDate = "";
        if (UserClockInUtils.isCurrentDay(logs.workStartDate!)) {
          todayDate =
              DateUtil.dateToString(DateTime.now(), DateUtil.DD_MM_YYYY_SLASH);
        } else {
          todayDate = logs.workStartDate ?? "";
        }

        if (UserClockInUtils.isCurrentDay(logs.workStartDate!)) {
          currentDateTime = DateTime.now();
        } else {
          currentDateTime = fullFormat.parse(
              "$todayDate ${DateUtil.changeDateFormat(logs.shiftInfo?.endTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");
        }

        final String shiftStart =
            "$todayDate ${DateUtil.changeDateFormat(logs.shiftInfo?.startTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";
        final String shiftEnd =
            "$todayDate ${DateUtil.changeDateFormat(logs.shiftInfo?.endTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";

        // print("shiftStart:" + shiftStart);
        // print("shiftEnd:" + shiftEnd);

        final DateTime shiftStartTime = fullFormat.parse(shiftStart);
        final DateTime shiftEndTime = fullFormat.parse(shiftEnd);

        for (var log in logs.workLogInfo!) {
          // print("============");
          if ((log.id ?? 0) != 0 && logs.shiftInfo?.id! == log.shiftId) {
            DateTime? workStartTime, workEndTime;

            String workStart = log.workStartTime ?? "";
            String workEnd = log.workEndTime ?? "";

            if (!StringHelper.isEmptyString(workEnd)) {
              totalWorkHourSeconds =
                  totalWorkHourSeconds + (log.payableWorkSeconds ?? 0);
              totalBreakHourSeconds =
                  totalBreakHourSeconds + (log.totalBreaklogSeconds ?? 0);
              // payableWorkHourSeconds =
              //     payableWorkHourSeconds + (log.payableWorkSeconds ?? 0);
            } else {
              if (fullFormat.parse(workStart).isBefore(shiftStartTime)) {
                workStartTime = shiftStartTime;
              } else if (fullFormat.parse(workStart).isAfter(shiftEndTime)) {
                workStartTime = shiftEndTime;
              } else {
                workStartTime = fullFormat.parse(workStart);
              }

              // if (StringHelper.isEmptyString(workEnd)) {
              if (currentDateTime.isBefore(shiftStartTime)) {
                workEndTime = shiftStartTime;
              } else if (currentDateTime.isAfter(shiftEndTime)) {
                workEndTime = shiftEndTime;
              } else {
                workEndTime = currentDateTime;
                insideShiftTime = true;
              }

              // totalWorkHourSeconds = totalWorkHourSeconds +
              //     DateUtil.dateDifferenceInSeconds(
              //         date1: workStartTime, date2: workEndTime);
              activeWorkSeconds = DateUtil.dateDifferenceInSeconds(
                  date1: workStartTime, date2: workEndTime);

              //Break hour calculate
              for (var breakInfo in logs.shiftInfo!.breaks!) {
                if (!StringHelper.isEmptyString(breakInfo.breakStartTime) &&
                    !StringHelper.isEmptyString(breakInfo.breakEndTime)) {
                  final String breakStart =
                      "$todayDate ${DateUtil.changeDateFormat(breakInfo.breakStartTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";
                  final String breakEnd =
                      "$todayDate ${DateUtil.changeDateFormat(breakInfo.breakEndTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";

                  DateTime? breakStartTime = fullFormat.parse(breakStart);
                  DateTime? breakEndTime = fullFormat.parse(breakEnd);

                  // Skip if break ends before work starts or starts after work ends
                  if (breakEndTime.isBefore(workStartTime) ||
                      breakStartTime.isAfter(workEndTime)) {
                    continue;
                  }

                  if (currentDateTime.isAfter(breakStartTime) &&
                      currentDateTime.isBefore(breakEndTime)) {
                    final remaining = breakEndTime.difference(currentDateTime);
                    remainingBreakSeconds = remaining.inSeconds;
                    isOnBreak = true;
                  }

                  // Clamp break time within workStart and workEnd
                  final actualStart = breakStartTime.isBefore(workStartTime)
                      ? workStartTime
                      : breakStartTime;
                  final actualEnd = breakEndTime.isAfter(workEndTime)
                      ? workEndTime
                      : breakEndTime;
                  Duration totalBreakTime = actualEnd.difference(actualStart);
                  // total += totalBreakTime;
                  totalBreakHourSeconds =
                      totalBreakHourSeconds + totalBreakTime.inSeconds;

                  if (StringHelper.isEmptyString(workEnd)) {
                    activeWorkSeconds =
                        activeWorkSeconds - totalBreakTime.inSeconds;
                  }
                }
              }

              totalWorkHourSeconds = totalWorkHourSeconds + activeWorkSeconds;
            }
          }
        }*/

        DateTime currentDateTime = DateTime.now();
        final DateFormat fullFormat =
            DateFormat(DateUtil.DD_MM_YYYY_TIME_24_SLASH2);

        String todayDate = "";
        if (UserClockInUtils.isCurrentDay(logs.workStartDate!)) {
          todayDate =
              DateUtil.dateToString(DateTime.now(), DateUtil.DD_MM_YYYY_SLASH);
        } else {
          todayDate = logs.workStartDate ?? "";
        }

        if (UserClockInUtils.isCurrentDay(logs.workStartDate!)) {
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

        bool isFullDayLeaveAvailable = hasFullDayLeave(logs.userLeaves);
        if (!isFullDayLeaveAvailable) {
          for (var log in logs.workLogInfo!) {
            if ((log.id ?? 0) == 0 || logs.shiftInfo?.id != log.shiftId)
              continue;

            DateTime workStartTime;
            DateTime workEndTime;

            final String workStart = log.workStartTime ?? "";
            final String workEnd = log.workEndTime ?? "";

            // ✅ Completed log (backend-calculated)
            if (!StringHelper.isEmptyString(workEnd)) {
              totalWorkHourSeconds += (log.payableWorkSeconds ?? 0);
              totalBreakHourSeconds += (log.totalBreaklogSeconds ?? 0);
              // print("-------------------------");
              // print("totalWorkHourSeconds:"+totalWorkHourSeconds.toString());
              continue;
            }

            // Clamp work start inside shift
            final DateTime parsedWorkStart = fullFormat.parse(workStart);
            if (parsedWorkStart.isBefore(shiftStartTime)) {
              workStartTime = shiftStartTime;
            } else if (parsedWorkStart.isAfter(shiftEndTime)) {
              workStartTime = shiftEndTime;
            } else {
              workStartTime = parsedWorkStart;
            }

            // Clamp work end (current time)
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

            // ===============================
            // 🔥 LEAVE CALCULATION (TOP PRIORITY)
            // ===============================
            int totalLeaveSeconds = 0;

            for (var leave in logs.userLeaves ?? []) {
              if (leave.isAlldayLeave == true) continue;

              final DateTime leaveStart = fullFormat.parse(
                  "$todayDate ${DateUtil.changeDateFormat(leave.startTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

              final DateTime leaveEnd = fullFormat.parse(
                  "$todayDate ${DateUtil.changeDateFormat(leave.endTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

              // ✅ isOnLeave flag
              if (currentDateTime.isAfter(leaveStart) &&
                  currentDateTime.isBefore(leaveEnd)) {
                isOnLeave = true;
              }

              totalLeaveSeconds += overlapSeconds(
                  workStartTime, workEndTime, leaveStart, leaveEnd);
            }

            activeWorkSeconds -= totalLeaveSeconds;
            if (activeWorkSeconds < 0) activeWorkSeconds = 0;

            // Leave overrides break
            if (isOnLeave) {
              isOnBreak = false;
              remainingBreakSeconds = 0;
            }

            // ===============================
            // ⏸️ BREAK CALCULATION (AFTER LEAVE)
            // ===============================
            for (var breakInfo in logs.shiftInfo!.breaks!) {
              if (StringHelper.isEmptyString(breakInfo.breakStartTime) ||
                  StringHelper.isEmptyString(breakInfo.breakEndTime)) continue;

              final DateTime breakStartTime = fullFormat.parse(
                  "$todayDate ${DateUtil.changeDateFormat(breakInfo.breakStartTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

              final DateTime breakEndTime = fullFormat.parse(
                  "$todayDate ${DateUtil.changeDateFormat(breakInfo.breakEndTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

              if (breakEndTime.isBefore(workStartTime) ||
                  breakStartTime.isAfter(workEndTime)) continue;

              // isOnBreak (only if not on leave)
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

              // Remove overlap with NON-ALLDAY leave
              for (var leave in logs.userLeaves ?? []) {
                if (leave.isAlldayLeave == true) continue;

                final DateTime leaveStart = fullFormat.parse(
                    "$todayDate ${DateUtil.changeDateFormat(leave.startTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

                final DateTime leaveEnd = fullFormat.parse(
                    "$todayDate ${DateUtil.changeDateFormat(leave.endTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");

                breakSeconds -= overlapSeconds(
                    actualStart, actualEnd, leaveStart, leaveEnd);
              }

              if (breakSeconds < 0) breakSeconds = 0;

              totalBreakHourSeconds += breakSeconds;
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

    // print("tota/*lWorkHourSeconds:" +
    //     DateUtil.seconds_To_HH_MM_SS(totalWorkHourSeconds));
    // print(
    //     "totalLeaveSeconds:" + DateUtil.seconds_To_HH_MM_SS(totalLeaveSeconds));
    // // print("totalLeaveSeconds:" + totalLeaveSeconds.toString());
    //
    // activeWorkSeconds = activeWorkSeconds - totalLeaveSeconds;
    // totalWorkHourSeconds = totalWorkHourSeconds - totalLeaveSeconds;

    var details = CounterDetails(
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
    return details;
  }

  static bool isCurrentDay(String inputDate) {
    DateTime? inputDateTime =
        DateUtil.stringToDate(inputDate, DateUtil.DD_MM_YYYY_SLASH);
    DateTime today = DateTime.now();
    bool isToday = inputDateTime?.year == today.year &&
        inputDateTime?.month == today.month &&
        inputDateTime?.day == today.day;
    return isToday;
  }

  static bool hasFullDayLeave(List<LeaveInfo>? leaves) {
    if (leaves == null || leaves.isEmpty) return false;

    return leaves.any((leave) => leave.isAlldayLeave == true);
  }

  /// All-day leave today — blocks start work for the whole day.
  static bool isUserOnAllDayLeaveToday(WorkLogListResponse? logs) {
    if (logs == null) return false;
    if (!isCurrentDay(logs.workStartDate ?? "")) return false;
    return hasFullDayLeave(logs.userLeaves);
  }

// static DateTime? getWorkCurrentDateTime(String inputDate) {
//   DateTime? inputDateTime =
//       DateUtil.stringToDate(inputDate, DateUtil.DD_MM_YYYY_SLASH);
//   DateTime now = DateTime.now();
//
//   DateTime updatedDate = DateTime(
//     inputDateTime!.year,
//     inputDateTime.month,
//     inputDateTime.day,
//     now.hour,
//     now.minute,
//     now.second,
//   );
//   return updatedDate;
// }

  static bool hasOfflineRecordsForUpload() {
    WorkLogListResponse workLogData =
        Get.find<AppStorage>().getWorklogDataOffline();
    workLogData.workLogInfo ??= <WorkLogInfo>[];
    for (final log in workLogData.workLogInfo ?? <WorkLogInfo>[]) {
      if (_isOfflineUploadCandidate(log)) return true;
    }
    return false;
  }

  static bool _isOfflineUploadCandidate(WorkLogInfo log) {
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

  /// True when work was stopped offline with end time and location (API expects
  /// both [work_end_time] and [stop_work_location] only in that case).
  static bool _hasStopWorkData(WorkLogInfo log) {
    if (StringHelper.isEmptyString(log.workEndTime)) return false;
    final loc = log.stopWorkLocation;
    if (loc == null) return false;
    return !StringHelper.isEmptyString(loc.latitude) ||
        !StringHelper.isEmptyString(loc.longitude) ||
        !StringHelper.isEmptyString(loc.location);
  }

  static Future<List<Map<String, dynamic>>> getOfflineRecordsUploadJson({
    int? selectedProjectId,
    int? selectedShiftId,
  }) async {
    WorkLogListResponse workLogData =
        Get.find<AppStorage>().getWorklogDataOffline();
    workLogData.workLogInfo ??= <WorkLogInfo>[];
    String deviceModelName = await AppUtils.getDeviceName();
    final List<Map<String, dynamic>> rows = [];
    for (final log in workLogData.workLogInfo ?? <WorkLogInfo>[]) {
      if (!_isOfflineUploadCandidate(log)) continue;
      final int workLogId = log.id ?? 0;
      // New offline-created row (id 0): server has no row yet — use UI selection.
      // Existing row stopped offline (id > 0): send stored shift/project as-is.
      final bool useSelectedProjectShift = workLogId == 0;

      final Map<String, dynamic> row = {
        "shift_id": useSelectedProjectShift ? selectedShiftId : log.shiftId,
        "project_id": useSelectedProjectShift ? selectedProjectId : log.projectId,
        "work_start_time": log.workStartTime,
        "start_work_location": log.startWorkLocation?.toJson(),
        "device_type": AppConstants.deviceType,
        "device_model_type": deviceModelName,
      };
      if (_hasStopWorkData(log)) {
        row["work_end_time"] = log.workEndTime;
        row["stop_work_location"] = log.stopWorkLocation!.toJson();
      }
      if ((log.id ?? 0) > 0) {
        row["id"] = log.id;
      }
      rows.add(row);
    }
    print("----------------------------------");
    StringHelper.printLongString(rows.toString());
    print("----------------------------------");

    return rows;
  }

  static void clearOfflineRecordsJson() {
    Get.find<AppStorage>()
        .removeData(AppConstants.sharedPreferenceKey.worklogDataOffline);
  }

  /// Keeps only offline rows whose [workStartTime] matches [workStartTime] (API conflict trim).
  static void retainOfflineWorklogsByStartTime(String workStartTime) {
    if (StringHelper.isEmptyString(workStartTime)) return;
    final storage = Get.find<AppStorage>();
    final workLogData = storage.getWorklogDataOffline();
    workLogData.workLogInfo ??= <WorkLogInfo>[];
    workLogData.workLogInfo = workLogData.workLogInfo!
        .where((log) => (log.workStartTime ?? '') == workStartTime)
        .toList();
    storage.setWorklogDataOffline(workLogData);
  }
}
