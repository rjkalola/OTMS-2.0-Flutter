import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveUtils {
  static Color getLeaveTypeColor(String leaveType) {
    Color color = primaryTextColorLight_(Get.context!);
    if (leaveType.toLowerCase() == "paid") {
      color = Colors.green;
    } else if (leaveType.toLowerCase() == "unpaid") {
      color = Colors.orange;
    }
    return color;
  }
}

enum LeaveCalendarDaySegment { single, start, middle, end }

class LeaveCalendarHelper {
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static bool isSameDay(DateTime a, DateTime b) {
    final dayA = dateOnly(a);
    final dayB = dateOnly(b);
    return dayA == dayB;
  }

  static DateTime? parseLeaveDate(String? value) {
    if (StringHelper.isEmptyString(value ?? "")) return null;
    return DateUtil.stringToDate(value!, DateUtil.DD_MM_YYYY_SLASH);
  }

  static List<DateTime> getDatesForLeave(LeaveInfo leave) {
    final start = parseLeaveDate(leave.startDate);
    if (start == null) return [];

    final startOnly = dateOnly(start);
    if (leave.isAlldayLeave ?? false) {
      final end = parseLeaveDate(leave.endDate) ?? start;
      final endOnly = dateOnly(end);
      final dates = <DateTime>[];
      var current = startOnly;
      while (!current.isAfter(endOnly)) {
        dates.add(current);
        current = current.add(const Duration(days: 1));
      }
      return dates;
    }
    return [startOnly];
  }

  static bool occursOnDay(LeaveInfo leave, DateTime day) {
    final dayOnly = dateOnly(day);
    return getDatesForLeave(leave).any((date) => date == dayOnly);
  }

  static List<LeaveInfo> leavesOnDay(List<LeaveInfo> leaves, DateTime day) {
    return leaves.where((leave) => occursOnDay(leave, day)).toList();
  }

  static LeaveCalendarDaySegment? getAllDaySegment(LeaveInfo leave, DateTime day) {
    if (!(leave.isAlldayLeave ?? false)) return null;
    final dates = getDatesForLeave(leave);
    if (dates.isEmpty || !occursOnDay(leave, day)) return null;
    if (dates.length == 1) return LeaveCalendarDaySegment.single;
    final dayOnly = dateOnly(day);
    if (dates.first == dayOnly) return LeaveCalendarDaySegment.start;
    if (dates.last == dayOnly) return LeaveCalendarDaySegment.end;
    return LeaveCalendarDaySegment.middle;
  }

  static BorderRadius segmentBorderRadius(LeaveCalendarDaySegment segment) {
    const radius = Radius.circular(6);
    switch (segment) {
      case LeaveCalendarDaySegment.single:
        return BorderRadius.circular(6);
      case LeaveCalendarDaySegment.start:
        return const BorderRadius.horizontal(left: radius);
      case LeaveCalendarDaySegment.end:
        return const BorderRadius.horizontal(right: radius);
      case LeaveCalendarDaySegment.middle:
        return BorderRadius.zero;
    }
  }

  static DateTime? initialFocusedDay(List<LeaveInfo> leaves) {
    final now = dateOnly(DateTime.now());
    for (final leave in leaves) {
      for (final date in getDatesForLeave(leave)) {
        if (date == now) return now;
      }
    }
    for (final leave in leaves) {
      final dates = getDatesForLeave(leave);
      if (dates.isNotEmpty) return dates.first;
    }
    return now;
  }
}
