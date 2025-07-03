import 'package:intl/intl.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/counter_details.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_list_response.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';

class ClockInUtils {
  static CounterDetails getTotalWorkHours(WorkLogListResponse? logs) {
    int totalWorkHourSeconds = 0,
        totalBreakHourSeconds = 0,
        remainingBreakSeconds = 0;
    bool isOnBreak = false;

    print("---------------");
    if (logs != null) {
      if (!(logs.userIsWorking ?? false)) {
        totalWorkHourSeconds = logs.totalPayableWorkingSeconds!;
      } else {
        DateTime currentDateTime = DateTime.now();
        final DateFormat fullFormat =
            DateFormat(DateUtil.DD_MM_YYYY_TIME_24_SLASH2);

        String todayDate = "";
        if (ClockInUtils.isCurrentDay(logs.workStartDate!)) {
          todayDate =
              DateUtil.dateToString(DateTime.now(), DateUtil.DD_MM_YYYY_SLASH);
        } else {
          todayDate = logs.workStartDate ?? "";
        }

        if (ClockInUtils.isCurrentDay(logs.workStartDate!)) {
          currentDateTime = DateTime.now();
        } else {
          currentDateTime = fullFormat.parse(
              "$todayDate ${DateUtil.changeDateFormat(logs.shiftInfo?.endTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");
        }

        final String shiftStart =
            "$todayDate ${DateUtil.changeDateFormat(logs.shiftInfo?.startTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";
        final String shiftEnd =
            "$todayDate ${DateUtil.changeDateFormat(logs.shiftInfo?.endTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";

        print("shiftStart:" + shiftStart);
        print("shiftEnd:" + shiftEnd);

        final DateTime shiftStartTime = fullFormat.parse(shiftStart);
        final DateTime shiftEndTime = fullFormat.parse(shiftEnd);

        for (var log in logs.workLogInfo!) {
          if ((log.id ?? 0) != 0 && logs.shiftInfo?.id! == log.shiftId) {
            DateTime? workStartTime, workEndTime;

            String workStart = log.workStartTime ?? "";
            String workEnd = log.workEndTime ?? "";

            if (fullFormat.parse(workStart).isBefore(shiftStartTime)) {
              workStartTime = shiftStartTime;
            } else if (fullFormat.parse(workStart).isAfter(shiftEndTime)) {
              workStartTime = shiftEndTime;
            } else {
              workStartTime = fullFormat.parse(workStart);
            }

            if (StringHelper.isEmptyString(workEnd)) {
              if (currentDateTime.isBefore(shiftStartTime)) {
                workEndTime = shiftStartTime;
              } else if (currentDateTime.isAfter(shiftEndTime)) {
                workEndTime = shiftEndTime;
              } else {
                workEndTime = currentDateTime;
              }
              print("Difference:" +
                  DateUtil.seconds_To_HH_MM_SS(DateUtil.dateDifferenceInSeconds(
                      date1: workStartTime, date2: workEndTime)));
              totalWorkHourSeconds = totalWorkHourSeconds +
                  DateUtil.dateDifferenceInSeconds(
                      date1: workStartTime, date2: workEndTime);
            } else {
              if (fullFormat.parse(workEnd).isBefore(shiftStartTime)) {
                workEndTime = shiftStartTime;
              } else if (fullFormat.parse(workEnd).isAfter(shiftEndTime)) {
                workEndTime = shiftEndTime;
              } else {
                workEndTime = fullFormat.parse(workEnd);
              }

              totalWorkHourSeconds = totalWorkHourSeconds +
                  DateUtil.dateDifferenceInSeconds(
                      date1: workStartTime, date2: workEndTime);

              // totalWorkHourSeconds =
              //     totalWorkHourSeconds + (log.totalWorkSeconds ?? 0);
            }
          }
        }

        //Break hour calculate
        for (var breakInfo in logs.shiftInfo!.breaks!) {
          if (!StringHelper.isEmptyString(breakInfo.breakStartTime) &&
              !StringHelper.isEmptyString(breakInfo.breakEndTime)) {
            final String breakStart =
                "$todayDate ${DateUtil.changeDateFormat(breakInfo.breakStartTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";
            final String breakEnd =
                "$todayDate ${DateUtil.changeDateFormat(breakInfo.breakEndTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";

            // print("breakStart:" + breakStart);
            // print("breakEnd:" + breakEnd);

            DateTime? breakStartTime, breakEndTime;

            if (currentDateTime.isAfter(fullFormat.parse(breakStart)) &&
                currentDateTime.isBefore(fullFormat.parse(breakEnd))) {
              breakStartTime = fullFormat.parse(breakStart);
              breakEndTime = currentDateTime;
              print("breakStart:" + breakStart);
              print("breakEnd:" + breakEnd);
              int totalSeconds = DateUtil.dateDifferenceInSeconds(
                  date1: breakStartTime, date2: breakEndTime);
              totalBreakHourSeconds = totalBreakHourSeconds + totalSeconds;

              int totalRemainingSeconds = (DateUtil.dateDifferenceInSeconds(
                      date1: fullFormat.parse(breakStart),
                      date2: fullFormat.parse(breakEnd))) -
                  totalSeconds;

              remainingBreakSeconds = totalRemainingSeconds;
              print(
                  "totalRemainingSeconds:" + totalRemainingSeconds.toString());

              isOnBreak = true;
            } else if (currentDateTime.isAfter(fullFormat.parse(breakStart)) &&
                currentDateTime.isAfter(fullFormat.parse(breakEnd))) {
              breakStartTime = fullFormat.parse(breakStart);
              breakEndTime = fullFormat.parse(breakEnd);
              totalBreakHourSeconds = totalBreakHourSeconds +
                  DateUtil.dateDifferenceInSeconds(
                      date1: breakStartTime, date2: breakEndTime);
            }
          }
        }
      }
    }
    int totalWorkTime = 0;
    if (totalWorkHourSeconds > totalBreakHourSeconds) {
      totalWorkTime = totalWorkHourSeconds - totalBreakHourSeconds;
    } else {
      totalWorkTime = totalWorkHourSeconds;
    }
    var details = CounterDetails(
        totalWorkSeconds: totalWorkTime,
        totalWorkTime: DateUtil.seconds_To_HH_MM_SS(totalWorkTime),
        remainingBreakTime: DateUtil.seconds_To_HH_MM_SS(remainingBreakSeconds),
        remainingBreakSeconds: remainingBreakSeconds,
        isOnBreak: isOnBreak);
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

  static DateTime? getWorkCurrentDateTime(String inputDate) {
    DateTime? inputDateTime =
        DateUtil.stringToDate(inputDate, DateUtil.DD_MM_YYYY_SLASH);
    DateTime now = DateTime.now();

    DateTime updatedDate = DateTime(
      inputDateTime!.year,
      inputDateTime.month,
      inputDateTime.day,
      now.hour,
      now.minute,
      now.second,
    );
    return updatedDate;
  }
}
