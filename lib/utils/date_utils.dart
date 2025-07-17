import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otm_inventory/pages/common/listener/select_date_range_listener.dart';
import 'package:otm_inventory/pages/common/listener/select_time_listener.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../pages/common/listener/select_date_listener.dart';

class DateUtil {
  static String changeDateFormat(String date, String format, String newFormat) {
    DateFormat inputDateFormat = DateFormat(format);
    DateTime inputDate = inputDateFormat.parse(date);
    DateFormat outputDateFormat = DateFormat(newFormat);
    return outputDateFormat.format(inputDate);
  }

  static DateTime? stringToDate(String date, String format) {
    if (StringHelper.isEmptyString(date) || StringHelper.isEmptyString(format))
      return null;

    DateTime? d = null;
    DateFormat mFormatter = DateFormat(format);
    try {
      d = mFormatter.parse(date);
    } catch (e) {
      d = null;
    }
    return d;
  }

  static String dateToString(DateTime? date, String format) {
    String result = "";
    if (date == null || StringHelper.isEmptyString(format)) return result;
    DateFormat mFormatter = DateFormat(format);
    try {
      result = mFormatter.format(date);
    } catch (e) {
      result = "";
    }
    return result;
  }

  static String timeToString(DateTime? time, String format) {
    String result = "";
    if (time == null || StringHelper.isEmptyString(format)) return result;
    // final now = DateTime.now();
    // final date = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    DateFormat mFormatter = DateFormat(format);
    try {
      result = mFormatter.format(time);
    } catch (e) {
      result = "";
    }
    return result;
  }

  static String seconds_To_MM_SS(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  static String seconds_To_HH_MM(int totalSeconds) {
    /* final duration = Duration(seconds: totalSeconds);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';*/

    final duration = Duration(seconds: totalSeconds);

    double totalMinutes = duration.inSeconds / 60;
    int roundedMinutes = totalMinutes.round();

    int hours = roundedMinutes ~/ 60;
    int minutes = roundedMinutes % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  static String seconds_To_HH_MM_SS(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  static String getCurrentTimeInFormat(String format) {
    final now = DateTime.now();
    final formatter = DateFormat(format);
    return formatter.format(now);
  }

  static int dateDifferenceInSeconds({DateTime? date1, DateTime? date2}) {
    Duration diff = date2!.difference(date1!);
    int totalSeconds = diff.inSeconds;
    return totalSeconds;
  }

  static TimeOfDay? getTimeOfDayFromHHMM(String? timeString) {
    if (timeString != null) {
      final parts = timeString.split(":");
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } else {
      return null;
    }
  }

  static DateTime? getDateTimeFromHHMM(String? timeString) {
    if (timeString != null) {
      final now = DateTime.now();
      final format = DateFormat(HH_MM_24); // 24-hour format
      final time = format.parse(timeString);
      return DateTime(now.year, now.month, now.day, time.hour, time.minute);
    } else {
      return null;
    }
  }

  static Future<void> showDateRangeDialog(
      {DateTime? initialFirstDate,
      DateTime? initialLastDate,
      required DateTime firstDate,
      required DateTime lastDate,
      required String dialogIdentifier,
      required SelectDateRangeListener listener}) async {
    /* final DateTimeRange? picked = await showDateRangePicker(
      context: Get.context!,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: DateTimeRange(
        start: initialFirstDate ?? DateTime.now().subtract(Duration(days: 7)),
        end: initialLastDate ?? DateTime.now(),
      ),
    );

    if (picked != null) {
      // print("Start: ${picked.start}, End: ${picked.end}");
      listener.onSelectDateRange(picked.start, picked.end, dialogIdentifier);
      AppUtils.setStatusBarColor();
    }*/

    /*AppUtils.setStatusBarColor();

    final DateTimeRange? picked = await showDateRangePicker(
      context: Get.context!,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: DateTimeRange(
        start: initialFirstDate ?? DateTime.now().subtract(Duration(days: 7)),
        end: initialLastDate ?? DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: Get.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          child: child!,
        );
      },
    );

    // ❗ Schedule restore TWICE: immediately and after frame
    AppUtils.setStatusBarColor(); // First try

    // Then try again after current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppUtils.setStatusBarColor();
    });

    // Then try one more after delay (really ensures it)
    Future.delayed(const Duration(milliseconds: 100), () {
      AppUtils.setStatusBarColor();
    });

    if (picked != null) {
      listener.onSelectDateRange(picked.start, picked.end, dialogIdentifier);
    }*/

    showDialog(
      context: Get.context!,
      barrierColor: Colors.black.withAlpha((0.3 * 255).toInt()),
      // dim background
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 16), // control width
        backgroundColor: Colors.transparent, // <-- prevent white box
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            color: backgroundColor_(context),
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.range,
              showActionButtons: true,
              // enableSwipeSelection: true, // Optional - only for swipe-selecting dates
              showNavigationArrow: true,
              backgroundColor: backgroundColor_(context),
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: backgroundColor_(context), // Header background
                textStyle: TextStyle(
                  color: primaryTextColor_(context), // Center date text
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              todayHighlightColor: CupertinoColors.systemBlue,
              startRangeSelectionColor: CupertinoColors.systemBlue,
              endRangeSelectionColor: CupertinoColors.systemBlue,
              rangeSelectionColor: CupertinoColors.systemBlue.withOpacity(0.25),
              selectionTextStyle: TextStyle(color: Colors.white),
              initialSelectedRange: PickerDateRange(
                initialFirstDate ?? DateTime.now().subtract(Duration(days: 7)),
                initialLastDate ?? DateTime.now(),
              ),
              onSubmit: (value) {
                if (value is PickerDateRange) {
                  final start = value.startDate;
                  final end = value.endDate;
                  listener.onSelectDateRange(start!, end!, dialogIdentifier);
                  print('Selected range: $start to $end');
                }
                Get.back();
              },
              onCancel: () => Get.back(),
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> showDatePickerDialog(
      {DateTime? initialDate,
      required DateTime firstDate,
      required DateTime lastDate,
      required String dialogIdentifier,
      required SelectDateListener selectDateListener}) async {
    if (Platform.isIOS) {
      DateTime initial = DateTime.now().subtract(Duration(minutes: 1));
      DateTime? selectedDate = initialDate;
      DateTime safeInitial = clampInitialDate(
        initial: initialDate ?? initial,
        minimum: firstDate,
        maximum: lastDate,
      );
      showCupertinoModalPopup(
        context: Get.context!,
        builder: (_) => Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              // Toolbar
              SizedBox(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TitleTextView(
                        text: "Cancel",
                        color: secondaryTextColor_(Get.context!),
                      ),
                      onPressed: () => Get.back(),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TitleTextView(
                        text: "Done",
                        color: defaultAccentColor_(Get.context!),
                      ),
                      onPressed: () {
                        selectDateListener.onSelectDate(
                            selectedDate ?? DateTime.now(), dialogIdentifier);
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              // Date Picker
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: safeInitial,
                  maximumDate: truncateToSeconds(lastDate),
                  minimumDate: truncateToSeconds(firstDate),
                  onDateTimeChanged: (DateTime date) {
                    selectedDate = date;
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else if (Platform.isAndroid) {
      final DateTime? picked = await showDatePicker(
        context: Get.context!,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );
      if (picked != null) {
        selectDateListener.onSelectDate(picked, dialogIdentifier);
      }
    }
  }

  static Future<void> showTimePickerDialog(
      {DateTime? initialTime,
      required String dialogIdentifier,
      required SelectTimeListener selectTimeListener}) async {
    if (Platform.isIOS) {
      DateTime selectedTime = initialTime ?? DateTime.now();
      showCupertinoModalPopup(
        context: Get.context!,
        builder: (_) => Container(
          height: 300,
          color: dashBoardBgColor_(Get.context!),
          child: Column(
            children: [
              // Toolbar
              SizedBox(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TitleTextView(
                        text: "Cancel",
                        color: secondaryTextColor_(Get.context!),
                      ),
                      onPressed: () => Get.back(),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TitleTextView(
                        text: "Done",
                        color: defaultAccentColor_(Get.context!),
                      ),
                      onPressed: () {
                        selectTimeListener.onSelectTime(
                            selectedTime, dialogIdentifier);
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              // Picker takes remaining space
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: initialTime ?? DateTime.now(),
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime newTime) {
                    selectedTime = newTime;
                    // Save or use time
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else if (Platform.isAndroid) {
      TimeOfDay initiallyTimeOfDay = initialTime != null
          ? convertDateTimeToTimeOfDay(initialTime)
          : TimeOfDay.now();
      final pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: initiallyTimeOfDay,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        selectTimeListener.onSelectTime(
            convertTimeOfDayToDateTime(pickedTime), dialogIdentifier);
      }
    }
  }

  static DateTime convertTimeOfDayToDateTime(TimeOfDay tod,
      {DateTime? baseDate}) {
    final now = baseDate ?? DateTime.now();
    return DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  }

  static TimeOfDay convertDateTimeToTimeOfDay(DateTime dt) {
    return TimeOfDay(hour: dt.hour, minute: dt.minute);
  }

  static DateTime truncateToSeconds(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);

  static DateTime clampInitialDate({
    required DateTime initial,
    required DateTime minimum,
    required DateTime maximum,
  }) {
    final min = truncateToSeconds(minimum);
    final max = truncateToSeconds(maximum);
    DateTime init = truncateToSeconds(initial);

    if (init.isBefore(min)) return min;
    if (init.isAfter(max)) return max;
    return init;
  }

  static DateTime clampAndTruncateDateTime({
    required DateTime initial,
    required DateTime min,
    required DateTime max,
  }) {
    // Truncate to seconds (remove microseconds)
    DateTime truncate(DateTime dt) =>
        DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);

    DateTime i = truncate(initial);
    DateTime minT = truncate(min);
    DateTime maxT = truncate(max);

    if (i.isBefore(minT)) return minT;
    if (i.isAfter(maxT)) return maxT;
    return i;
  }

  static List<DateTime> getMyRequestsDateRange(String filterType) {
    DateTime today = DateTime.now();
    DateTime startOfWeek = DateTime.now(), endOfWeek = DateTime.now();
    if (filterType == "Week") {
      final start = today.subtract(Duration(days: today.weekday - 1));
      final end = start.add(Duration(days: 6));
      startOfWeek = start;
      endOfWeek = end;
    } else if (filterType == "Month") {
      final start = DateTime(today.year, today.month, 1);
      final end = DateTime(today.year, today.month + 1, 0);
      startOfWeek = start;
      endOfWeek = end;
    } else if (filterType == "3 Month") {
      final start = DateTime(today.year, today.month - 2, 1);
      final end = DateTime(today.year, today.month + 1, 0);
      startOfWeek = start;
      endOfWeek = end;
    } else if (filterType == "6 Month") {
      final start = DateTime(today.year, today.month - 5, 1);
      final end = DateTime(today.year, today.month + 1, 0);
      startOfWeek = start;
      endOfWeek = end;
    } else if (filterType == "Year") {
      final start = DateTime(today.year, 1, 1);
      final end = DateTime(today.year, 12, 31);
      startOfWeek = start;
      endOfWeek = end;
    }
    return [startOfWeek, endOfWeek];
  }

  static List<DateTime> getDateWeekRange(String filterType) {
    DateTime now = DateTime.now();

    DateTime start = DateTime.now(), end = DateTime.now();
    if (filterType == "Week") {
      // Start of week (Monday)
      start = now.subtract(Duration(days: now.weekday - 1));
      // End of week (Sunday)
      end = start.add(Duration(days: 6));
    } else if (filterType == "Previous Week") {
      /*   DateTime startOfCurrentWeek =
      now.subtract(Duration(days: now.weekday - 1));
      // Start of previous week
      start = startOfCurrentWeek.subtract(Duration(days: 7));
      end = start.add(Duration(days: 6));*/

      // Get current week's weekday (1 = Monday, 7 = Sunday)
      int currentWeekday = now.weekday;
      start = now.subtract(Duration(days: currentWeekday + 6));
      // Current week's Sunday
      end = now.add(Duration(days: 7 - currentWeekday));
    } else if (filterType == "2 Weeks ago") {
      /*  // Start of current week (Monday)
      DateTime startOfCurrentWeek =
      now.subtract(Duration(days: now.weekday - 1));

      // Start of the week 2 weeks ago
      start = startOfCurrentWeek.subtract(Duration(days: 14));
      end = start.add(Duration(days: 6));*/

      // Weekday: Monday = 1, Sunday = 7
      int weekday = now.weekday;
      // 2 weeks ago Monday
      start = now.subtract(Duration(days: weekday + 13));
      // Current week's Sunday
      end = now.add(Duration(days: 7 - weekday));
    } else if (filterType == "Month") {
      start = DateTime(now.year, now.month, 1);
      end = DateTime(now.year, now.month + 1, 0);
    } else if (filterType == "3 Month") {
      start = DateTime(now.year, now.month - 2, 1);
      end = DateTime(now.year, now.month + 1, 0);
    } else if (filterType == "6 Month") {
      start = DateTime(now.year, now.month - 5, 1);
      end = DateTime(now.year, now.month + 1, 0);
    } else if (filterType == "Year") {
      start = DateTime(now.year, 1, 1);
      end = DateTime(now.year, 12, 31);
    }

    return [start, end];
  }

  static String DD_MM_YYYY_DASH = "dd-MM-yyyy";

  static String DD_MM_YYYY_TIME_12_DASH = "dd-MM-yyyy hh:mm a";

  static String DD_MM_YYYY_TIME_24_DASH = "dd-MM-yyyy HH:mm";

  static String DD_MM_YYYY_SLASH = "dd/MM/yyyy";

  static String MM_DD_SLASH = "MM/dd";

  static String DD_MM_YYYY_TIME_12_SLASH = "dd/MM/yyyy hh:mm a";

  static String DD_MM_YYYY_TIME_24_SLASH = "dd/MM/yyyy HH:mm";

  static String DD_MM_YYYY_TIME_24_SLASH2 = "dd/MM/yyyy HH:mm:ss";

  static String MM_DD_YYYY_DASH = "MM-dd-yyyy";

  static String MM_DD_YYYY_TIME_12_DASH = "MM-dd-yyyy hh:mm a";

  static String MM_DD_YYYY_TIME_24_DASH = "MM-dd-yyyy HH:mm";

  static String MM_DD_YYYY_SLASH = "MM/dd/yyyy";

  static String MM_DD_YYYY_TIME_12_SLASH = "MM/dd/yyyy hh:mm a";

  static String MM_DD_YYYY_TIME_24_SLASH = "MM/dd/yyyy HH:mm";

  static String YYYY_MM_DD_DASH = "yyyy-MM-dd";

  static String YYYY_MM_DD_TIME_12_DASH = "yyyy-MM-dd hh:mm a";

//    static String YYYY_MM_DD_TIME_12_DASH2 = "yyyy-MM-dd KK:mm";

  static String YYYY_MM_DD_TIME_24_DASH = "yyyy-MM-dd HH:mm";

  static String YYYY_MM_DD_TIME_24_DASH2 = "yyyy-MM-dd HH:mm:ss";

  static String YYYY_MM_DD_TIME_24_WITHOUT_QUOTE = "yyyyMMddHHmmss";

  static String YYYY_MM_DD_SLASH = "yyyy/MM/dd";

  static String YYYY_MM_DD_TIME_12_SLASH = "yyyy/MM/dd hh:mm a";

  static String YYYY_MM_DD_TIME_24_SLASH = "yyyy/MM/dd HH:mm";

  static String TIME_12_SLASH = "hh:mm a";

  static String DD_MMMM_YYYY_SPACE = "dd MMMM yyyy";

  static String DD_MMMM_YYYY_TIME_12_SPACE = "dd MMMM yyyy hh:mm a";

  static String DD_MMMM_YYYY_TIME_24_SPACE = "dd MMMM yyyy HH:mm";

  static String DD_MMMM_YYYY_DASH = "dd-MMMM-yyyy";

  static String DD_MMMM_YYYY_TIME_12_DASH = "dd-MMMM-yyyy hh:mm a";

  static String DD_MMMM_YYYY_TIME_24_DASH = "dd-MMMM-yyyy HH:mm";

  static String DD_MMMM_YYYY_SLASH = "dd/MMMM/yyyy";

  static String DD_MMMM_YYYY_TIME_12_SLASH = "dd/MMMM/yyyy hh:mm a";

  static String DD_MMMM_YYYY_TIME_24_SLASH = "dd/MMMM/yyyy HH:mm";

  static String DD_MMM_YYYY_SPACE = "dd MMM yyyy";

  static String DD_MMM_YYYY_TIME_12_SPACE = "dd MMM yyyy hh:mm a";

  static String DD_MMM_YYYY_TIME_24_SPACE = "dd MMM yyyy HH:mm";

  static String DD_MMM_YYYY_DASH = "dd-MMM-yyyy";

  static String DD_MMM_YYYY_TIME_12_DASH = "dd-MMM-yyyy hh:mm a";

  static String DD_MMM_YYYY_TIME_24_DASH = "dd-MMM-yyyy HH:mm";

  static String DD_MMM_YYYY_SLASH = "dd/MMM/yyyy";

  static String DD_MMM_YYYY_TIME_12_SLASH = "dd/MMM/yyyy hh:mm a";

  static String DD_MMM_YYYY_TIME_24_SLASH = "dd/MMM/yyyy HH:mm";

  static String DD_MMM_SPACE = "dd MMM";

  static String DD_MMMM_SPACE = "dd MMMM";

  static String MM_YYYY_SLASH = "MM/yyyy";

  static String DD_MMM_TIME_12_SPACE = "dd MMM hh:mm a";

  static String DD_MMM_TIME_24_SPACE = "dd MMM HH:mm";

  static String DD_MM_YYYY_DOT = "dd.MM.yyyy";

  static String DD_MM_YYYY_TIME_12_DOT = "dd.MM.yyyy hh:mm a";

  static String DD_MM_YYYY_TIME_24_DOT = "dd.MM.yyyy HH:mm";

  static String YY_MM_DD_DOT = "yyyy.MM.dd";

  static String YYYY_MM_DD_TIME_12_DOT = "yyyy.MM.dd hh:mm a";

  static String YYYY_MM_DD_TIME_24_DOT = "yyyy.MM.dd HH:mm";

  static String HH_MM_12 = "hh:mm a";

  static String HH_MM = "hh:mm";

  static String HH_MM_24 = "HH:mm";

  static String HH_MM_SS_24_2 = "HH:mm:ss";

  static String HH_MM_SS_24 = "hh:mm:ss";

  static String DD_MMM_EEE_SPACE = "dd MMM (EEE)";

  static String DD_MMM_YYYY_EEE_SPACE = "dd MMM yyyy (EEE)";

  static String DD_MMM_EEE_COMMA_SPACE_HH_MM_24 = "dd MMM, HH:mm";

  static String DD_MMMM_YYYY_TIME_24 = "dd MMMM yyyy HH:mm:ss";
}
