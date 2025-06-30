import 'package:intl/intl.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_list_response.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';

class ClockInUtils {
  static String getTotalWorkHours(WorkLogListResponse? logs) {
    int totalWorkHourSeconds = 0, totalBreakHourSeconds = 0;
    print("---------------");
    if (logs != null) {
      if (!(logs.userIsWorking ?? false)) {
        totalWorkHourSeconds = logs.totalWorkingHours!;
      } else {
        DateTime currentDateTime = DateTime.now();
        final DateFormat fullFormat =
            DateFormat(DateUtil.DD_MM_YYYY_TIME_24_SLASH2);

        String todayDate = "";
        if (ClockInUtils.isCurrentDay(logs.workStartDate!)) {
          todayDate =
              DateUtil.dateToString(DateTime.now(), DateUtil.DD_MM_YYYY_SLASH);
        } else {
          todayDate = DateUtil.changeDateFormat(logs.workStartDate!,
              DateUtil.YYYY_MM_DD_DASH, DateUtil.DD_MM_YYYY_SLASH);
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
              totalBreakHourSeconds = totalBreakHourSeconds +
                  DateUtil.dateDifferenceInSeconds(
                      date1: breakStartTime, date2: breakEndTime);
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
    return DateUtil.seconds_To_HH_MM_SS(
        totalWorkHourSeconds - totalBreakHourSeconds);
  }

  static bool isCurrentDay(String inputDate) {
    DateTime? inputDateTime =
        DateUtil.stringToDate(inputDate, DateUtil.YYYY_MM_DD_DASH);
    DateTime today = DateTime.now();
    bool isToday = inputDateTime?.year == today.year &&
        inputDateTime?.month == today.month &&
        inputDateTime?.day == today.day;
    return isToday;
  }

  static DateTime? getWorkCurrentDateTime(String inputDate) {
    DateTime? inputDateTime =
        DateUtil.stringToDate(inputDate, DateUtil.YYYY_MM_DD_DASH);
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
