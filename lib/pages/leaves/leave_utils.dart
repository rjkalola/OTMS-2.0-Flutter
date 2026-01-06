import 'package:belcka/res/colors.dart';
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
