import 'package:intl/intl.dart';
import 'package:belcka/pages/check_in/clock_in/model/counter_details.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_list_response.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';

import 'package:intl/intl.dart';
import 'package:belcka/pages/check_in/clock_in/model/counter_details.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_list_response.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';

class ClockInUtils {
  static CounterDetails getTotalWorkHours(WorkLogListResponse? logs) {
    int totalWorkHourSeconds = 0;
    int activeWorkSeconds = 0;
    int totalBreakHourSeconds = 0;
    int remainingBreakSeconds = 0;

    bool isOnBreak = false;
    bool insideShiftTime = false;

    // 🔒 SAFE EMPTY RETURN
    if (logs == null ||
        logs.workLogInfo == null ||
        logs.shiftInfo == null ||
        StringHelper.isEmptyString(logs.workStartDate)) {
      return _emptyCounter();
    }

    final DateFormat fullFormat =
    DateFormat(DateUtil.DD_MM_YYYY_TIME_24_SLASH2);

    final String workDay = logs.workStartDate!;

    // 🔒 Guard shift times
    if (StringHelper.isEmptyString(logs.shiftInfo!.startTime) ||
        StringHelper.isEmptyString(logs.shiftInfo!.endTime)) {
      return _emptyCounter();
    }

    final String shiftStart =
        "$workDay ${DateUtil.changeDateFormat(logs.shiftInfo!.startTime!, DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";

    final String shiftEnd =
        "$workDay ${DateUtil.changeDateFormat(logs.shiftInfo!.endTime!, DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";

    DateTime shiftStartTime = fullFormat.parse(shiftStart);
    DateTime shiftEndTime = fullFormat.parse(shiftEnd);

    // 🌙 Night shift support
    if (shiftEndTime.isBefore(shiftStartTime)) {
      shiftEndTime = shiftEndTime.add(const Duration(days: 1));
    }

    // 🔒 Freeze after shift end
    DateTime now = DateTime.now();
    DateTime effectiveCurrentTime;

    if (now.isAfter(shiftEndTime)) {
      effectiveCurrentTime = shiftEndTime;
      insideShiftTime = false;
    } else if (now.isBefore(shiftStartTime)) {
      effectiveCurrentTime = shiftStartTime;
      insideShiftTime = false;
    } else {
      effectiveCurrentTime = now;
      insideShiftTime = true;
    }

    for (var log in logs.workLogInfo!) {
      if ((log.id ?? 0) == 0 || logs.shiftInfo!.id != log.shiftId) continue;

      if (StringHelper.isEmptyString(log.workStartTime)) continue;

      DateTime workStartTime = fullFormat.parse(log.workStartTime!);

      if (workStartTime.isBefore(shiftStartTime)) {
        workStartTime = shiftStartTime;
      }

      // ✅ COMPLETED LOG
      if (!StringHelper.isEmptyString(log.workEndTime)) {
        DateTime workEndTime = fullFormat.parse(log.workEndTime!);

        if (workEndTime.isAfter(shiftEndTime)) {
          workEndTime = shiftEndTime;
        }

        totalWorkHourSeconds += log.payableWorkSeconds ?? 0;
        totalBreakHourSeconds += log.totalBreaklogSeconds ?? 0;
        continue;
      }

      // 🔄 RUNNING LOG (FROZEN AFTER SHIFT END)
      DateTime workEndTime = effectiveCurrentTime;

      int runningSeconds = DateUtil.dateDifferenceInSeconds(
        date1: workStartTime,
        date2: workEndTime,
      );

      // 🔹 Break calculation
      if (logs.shiftInfo!.breaks != null) {
        for (var breakInfo in logs.shiftInfo!.breaks!) {
          if (StringHelper.isEmptyString(breakInfo.breakStartTime) ||
              StringHelper.isEmptyString(breakInfo.breakEndTime)) continue;

          final String breakStart =
              "$workDay ${DateUtil.changeDateFormat(breakInfo.breakStartTime!, DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";

          final String breakEnd =
              "$workDay ${DateUtil.changeDateFormat(breakInfo.breakEndTime!, DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";

          DateTime breakStartTime = fullFormat.parse(breakStart);
          DateTime breakEndTime = fullFormat.parse(breakEnd);

          // 🌙 Break crosses midnight
          if (breakEndTime.isBefore(breakStartTime)) {
            breakEndTime = breakEndTime.add(const Duration(days: 1));
          }

          if (breakEndTime.isBefore(workStartTime) ||
              breakStartTime.isAfter(workEndTime)) continue;

          final DateTime actualStart =
          breakStartTime.isBefore(workStartTime)
              ? workStartTime
              : breakStartTime;
          final DateTime actualEnd =
          breakEndTime.isAfter(workEndTime)
              ? workEndTime
              : breakEndTime;

          final int breakSeconds =
              actualEnd.difference(actualStart).inSeconds;

          runningSeconds -= breakSeconds;
          totalBreakHourSeconds += breakSeconds;

          if (!effectiveCurrentTime.isBefore(breakStartTime) &&
              effectiveCurrentTime.isBefore(breakEndTime)) {
            remainingBreakSeconds =
                breakEndTime.difference(effectiveCurrentTime).inSeconds;
            isOnBreak = true;
          }
        }
      }

      activeWorkSeconds += runningSeconds;
      totalWorkHourSeconds += runningSeconds;
    }

    return CounterDetails(
      totalWorkSeconds: totalWorkHourSeconds,
      activeWorkSeconds: activeWorkSeconds,
      totalWorkTime:
      DateUtil.seconds_To_HH_MM_SS(totalWorkHourSeconds),
      remainingBreakTime:
      DateUtil.seconds_To_HH_MM_SS(remainingBreakSeconds),
      remainingBreakSeconds: remainingBreakSeconds,
      isOnBreak: isOnBreak,
      insideShiftTime: insideShiftTime,
    );
  }

  static CounterDetails _emptyCounter() {
    return CounterDetails(
      totalWorkSeconds: 0,
      activeWorkSeconds: 0,
      totalWorkTime: DateUtil.seconds_To_HH_MM_SS(0),
      remainingBreakTime: DateUtil.seconds_To_HH_MM_SS(0),
      remainingBreakSeconds: 0,
      isOnBreak: false,
      insideShiftTime: false,
    );
  }

  static bool isCurrentDay(String inputDate) {
    DateTime? inputDateTime =
    DateUtil.stringToDate(inputDate, DateUtil.DD_MM_YYYY_SLASH);
    DateTime today = DateTime.now();
    return inputDateTime?.year == today.year &&
        inputDateTime?.month == today.month &&
        inputDateTime?.day == today.day;
  }
}



// class ClockInUtils {
//   static CounterDetails getTotalWorkHours(WorkLogListResponse? logs) {
//     int totalWorkHourSeconds = 0,
//         activeWorkSeconds = 0,
//         totalBreakHourSeconds = 0,
//         remainingBreakSeconds = 0;
//     bool isOnBreak = false, insideShiftTime = false;
//
//     if (logs != null) {
//       if (!(logs.userIsWorking ?? false)) {
//         totalWorkHourSeconds = logs.totalPayableWorkingSeconds!;
//       } else {
//         DateTime currentDateTime = DateTime.now();
//         final DateFormat fullFormat =
//             DateFormat(DateUtil.DD_MM_YYYY_TIME_24_SLASH2);
//
//         String todayDate = "";
//         if (ClockInUtils.isCurrentDay(logs.workStartDate!)) {
//           todayDate =
//               DateUtil.dateToString(DateTime.now(), DateUtil.DD_MM_YYYY_SLASH);
//         } else {
//           todayDate = logs.workStartDate ?? "";
//         }
//
//         if (ClockInUtils.isCurrentDay(logs.workStartDate!)) {
//           currentDateTime = DateTime.now();
//         } else {
//           currentDateTime = fullFormat.parse(
//               "$todayDate ${DateUtil.changeDateFormat(logs.shiftInfo?.endTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}");
//         }
//
//         final String shiftStart =
//             "$todayDate ${DateUtil.changeDateFormat(logs.shiftInfo?.startTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";
//         final String shiftEnd =
//             "$todayDate ${DateUtil.changeDateFormat(logs.shiftInfo?.endTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";
//
//         // print("shiftStart:" + shiftStart);
//         // print("shiftEnd:" + shiftEnd);
//
//         final DateTime shiftStartTime = fullFormat.parse(shiftStart);
//         final DateTime shiftEndTime = fullFormat.parse(shiftEnd);
//
//         for (var log in logs.workLogInfo!) {
//           // print("============");
//           if ((log.id ?? 0) != 0 && logs.shiftInfo?.id! == log.shiftId) {
//             DateTime? workStartTime, workEndTime;
//
//             String workStart = log.workStartTime ?? "";
//             String workEnd = log.workEndTime ?? "";
//
//             if (!StringHelper.isEmptyString(workEnd)) {
//               totalWorkHourSeconds =
//                   totalWorkHourSeconds + (log.payableWorkSeconds ?? 0);
//               totalBreakHourSeconds =
//                   totalBreakHourSeconds + (log.totalBreaklogSeconds ?? 0);
//               // payableWorkHourSeconds =
//               //     payableWorkHourSeconds + (log.payableWorkSeconds ?? 0);
//             } else {
//               if (fullFormat.parse(workStart).isBefore(shiftStartTime)) {
//                 workStartTime = shiftStartTime;
//               } else if (fullFormat.parse(workStart).isAfter(shiftEndTime)) {
//                 workStartTime = shiftEndTime;
//               } else {
//                 workStartTime = fullFormat.parse(workStart);
//               }
//
//               // if (StringHelper.isEmptyString(workEnd)) {
//               if (currentDateTime.isBefore(shiftStartTime)) {
//                 workEndTime = shiftStartTime;
//               } else if (currentDateTime.isAfter(shiftEndTime)) {
//                 workEndTime = shiftEndTime;
//               } else {
//                 workEndTime = currentDateTime;
//                 insideShiftTime = true;
//               }
//
//               // totalWorkHourSeconds = totalWorkHourSeconds +
//               //     DateUtil.dateDifferenceInSeconds(
//               //         date1: workStartTime, date2: workEndTime);
//               activeWorkSeconds = DateUtil.dateDifferenceInSeconds(
//                   date1: workStartTime, date2: workEndTime);
//
//               //Break hour calculate
//               for (var breakInfo in logs.shiftInfo!.breaks!) {
//                 if (!StringHelper.isEmptyString(breakInfo.breakStartTime) &&
//                     !StringHelper.isEmptyString(breakInfo.breakEndTime)) {
//                   final String breakStart =
//                       "$todayDate ${DateUtil.changeDateFormat(breakInfo.breakStartTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";
//                   final String breakEnd =
//                       "$todayDate ${DateUtil.changeDateFormat(breakInfo.breakEndTime ?? "", DateUtil.HH_MM_24, DateUtil.HH_MM_SS_24_2)}";
//
//                   DateTime? breakStartTime = fullFormat.parse(breakStart);
//                   DateTime? breakEndTime = fullFormat.parse(breakEnd);
//
//                   // Skip if break ends before work starts or starts after work ends
//                   if (breakEndTime.isBefore(workStartTime) ||
//                       breakStartTime.isAfter(workEndTime)) {
//                     continue;
//                   }
//
//                   if (currentDateTime.isAfter(breakStartTime) &&
//                       currentDateTime.isBefore(breakEndTime)) {
//                     final remaining = breakEndTime.difference(currentDateTime);
//                     remainingBreakSeconds = remaining.inSeconds;
//                     isOnBreak = true;
//                   }
//
//                   // Clamp break time within workStart and workEnd
//                   final actualStart = breakStartTime.isBefore(workStartTime)
//                       ? workStartTime
//                       : breakStartTime;
//                   final actualEnd = breakEndTime.isAfter(workEndTime)
//                       ? workEndTime
//                       : breakEndTime;
//                   Duration totalBreakTime = actualEnd.difference(actualStart);
//                   // total += totalBreakTime;
//                   totalBreakHourSeconds =
//                       totalBreakHourSeconds + totalBreakTime.inSeconds;
//
//                   if (StringHelper.isEmptyString(workEnd)) {
//                     activeWorkSeconds =
//                         activeWorkSeconds - totalBreakTime.inSeconds;
//                   }
//                 }
//               }
//
//               totalWorkHourSeconds = totalWorkHourSeconds + activeWorkSeconds;
//             }
//           }
//         }
//       }
//     }
//
//     /* int totalWorkTime = 0;
//     if (totalWorkHourSeconds > totalBreakHourSeconds) {
//       totalWorkTime = totalWorkHourSeconds - totalBreakHourSeconds;
//     } else {
//       totalWorkTime = totalWorkHourSeconds;
//     }*/
//
//     var details = CounterDetails(
//         totalWorkSeconds: totalWorkHourSeconds,
//         activeWorkSeconds: activeWorkSeconds,
//         totalWorkTime: DateUtil.seconds_To_HH_MM_SS(totalWorkHourSeconds),
//         remainingBreakTime: DateUtil.seconds_To_HH_MM_SS(remainingBreakSeconds),
//         remainingBreakSeconds: remainingBreakSeconds,
//         isOnBreak: isOnBreak,
//         insideShiftTime: insideShiftTime);
//     return details;
//   }
//
//   static bool isCurrentDay(String inputDate) {
//     DateTime? inputDateTime =
//         DateUtil.stringToDate(inputDate, DateUtil.DD_MM_YYYY_SLASH);
//     DateTime today = DateTime.now();
//     bool isToday = inputDateTime?.year == today.year &&
//         inputDateTime?.month == today.month &&
//         inputDateTime?.day == today.day;
//     return isToday;
//   }
//
//   // static DateTime? getWorkCurrentDateTime(String inputDate) {
//   //   DateTime? inputDateTime =
//   //       DateUtil.stringToDate(inputDate, DateUtil.DD_MM_YYYY_SLASH);
//   //   DateTime now = DateTime.now();
//   //
//   //   DateTime updatedDate = DateTime(
//   //     inputDateTime!.year,
//   //     inputDateTime.month,
//   //     inputDateTime.day,
//   //     now.hour,
//   //     now.minute,
//   //     now.second,
//   //   );
//   //   return updatedDate;
//   // }
// }
