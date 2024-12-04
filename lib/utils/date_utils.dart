import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otm_inventory/utils/string_helper.dart';

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

  static Future<void> showDatePickerDialog(
      DateTime? initialDate,
      DateTime firstDate,
      DateTime lastDate,
      String dialogIdentifier,
      SelectDateListener listener) async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      listener.onSelectDate(picked, dialogIdentifier);
    }
  }

  static String DD_MM_YYYY_DASH = "dd-MM-yyyy";

  static String DD_MM_YYYY_TIME_12_DASH = "dd-MM-yyyy hh:mm a";

  static String DD_MM_YYYY_TIME_24_DASH = "dd-MM-yyyy HH:mm";

  static String DD_MM_YYYY_SLASH = "dd/MM/yyyy";

  static String MM_DD_SLASH = "MM/dd";

  static String DD_MM_YYYY_TIME_12_SLASH = "dd/MM/yyyy hh:mm a";

  static String DD_MM_YYYY_TIME_24_SLASH = "dd/MM/yyyy HH:mm";

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
