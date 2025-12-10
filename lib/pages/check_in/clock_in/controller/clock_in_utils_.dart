import 'package:intl/intl.dart';
import 'package:belcka/pages/check_in/clock_in/model/counter_details.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_list_response.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';

class ClockInUtils2 {
  static CounterDetails getTotalWorkHours(WorkLogListResponse? logs) {
    int totalWorkHourSeconds = 0,
        activeWorkSeconds = 0,
        totalBreakHourSeconds = 0,
        remainingBreakSeconds = 0;
    bool isOnBreak = false, insideShiftTime = false;

    if (logs != null) {
      if (!(logs.userIsWorking ?? false)) {
        totalWorkHourSeconds = logs.totalPayableWorkingSeconds!;
      } else {
        DateTime currentDateTime = DateTime.now();
        final DateFormat fullFormat =
            DateFormat(DateUtil.DD_MM_YYYY_TIME_24_SLASH2);

        String todayDate = "";
        if (isCurrentDay(logs.workStartDate!)) {
          todayDate =
              DateUtil.dateToString(DateTime.now(), DateUtil.DD_MM_YYYY_SLASH);
        } else {
          todayDate = logs.workStartDate ?? "";
        }

        if (isCurrentDay(logs.workStartDate!)) {
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
                insideShiftTime = true;
              }
              totalWorkHourSeconds = totalWorkHourSeconds +
                  DateUtil.dateDifferenceInSeconds(
                      date1: workStartTime, date2: workEndTime);
              activeWorkSeconds = DateUtil.dateDifferenceInSeconds(
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
            }

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

                /*  if (currentDateTime.isAfter(fullFormat.parse(breakStart)) &&
                    currentDateTime.isBefore(fullFormat.parse(breakEnd))) {
                  breakStartTime = fullFormat.parse(breakStart);
                  breakEndTime = currentDateTime;
                  // print("breakStart:" + breakStart);
                  // print("breakEnd:" + breakEnd);
                  int totalSeconds = DateUtil.dateDifferenceInSeconds(
                      date1: breakStartTime, date2: breakEndTime);
                  print("break:" + totalSeconds.toString());
                  totalBreakHourSeconds = totalBreakHourSeconds + totalSeconds;

                  int totalRemainingSeconds = (DateUtil.dateDifferenceInSeconds(
                          date1: fullFormat.parse(breakStart),
                          date2: fullFormat.parse(breakEnd))) -
                      totalSeconds;

                  remainingBreakSeconds = totalRemainingSeconds;
                  // print(
                  //     "totalRemainingSeconds:" + totalRemainingSeconds.toString());

                  isOnBreak = true;
                } else if (currentDateTime
                        .isAfter(fullFormat.parse(breakStart)) &&
                    currentDateTime.isAfter(fullFormat.parse(breakEnd))) {
                  breakStartTime = fullFormat.parse(breakStart);
                  breakEndTime = fullFormat.parse(breakEnd);
                  totalBreakHourSeconds = totalBreakHourSeconds +
                      DateUtil.dateDifferenceInSeconds(
                          date1: breakStartTime, date2: breakEndTime);
                  print("break:" +
                      DateUtil.dateDifferenceInSeconds(
                              date1: breakStartTime, date2: breakEndTime)
                          .toString());
                }*/
              }
            }
          }
        }
      }
    }
    // print("totalWorkHourSeconds:"+totalWorkHourSeconds.toString());
    // print("totalBreakHourSeconds:"+totalBreakHourSeconds.toString());
    int totalWorkTime = 0;
    if (totalWorkHourSeconds > totalBreakHourSeconds) {
      totalWorkTime = totalWorkHourSeconds - totalBreakHourSeconds;
    } else {
      totalWorkTime = totalWorkHourSeconds;
    }
    var details = CounterDetails(
        totalWorkSeconds: totalWorkTime,
        activeWorkSeconds: activeWorkSeconds,
        totalWorkTime: DateUtil.seconds_To_HH_MM_SS(totalWorkTime),
        remainingBreakTime: DateUtil.seconds_To_HH_MM_SS(remainingBreakSeconds),
        remainingBreakSeconds: remainingBreakSeconds,
        isOnBreak: isOnBreak,
        insideShiftTime: insideShiftTime);
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
