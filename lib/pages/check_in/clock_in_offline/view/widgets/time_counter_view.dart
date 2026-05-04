import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/clock_in/controller/clock_in_controller.dart';
import 'package:belcka/pages/check_in/clock_in/controller/clock_in_utils.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class TimeCounterView extends StatelessWidget {
  TimeCounterView({super.key});

  final controller = Get.put(ClockInController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: dividerColor_(context)),
            borderRadius: BorderRadius.circular(16),
            color: getBoxColor()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            PrimaryTextView(
              text: getStatusText(),
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            PrimaryTextView(
              text: getCounterTime(),
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Color getBoxColor() {
    if (controller.isOnLeave.value) {
      return Colors.grey;
    } else if (controller.isOnBreak.value) {
      return Color(0xffCE6700);
    } else {
      return Color(0xff007AFF);
    }
  }

  String getStatusText() {
    if (controller.isOnLeave.value) {
      return "";
    } else if (controller.isOnBreak.value) {
      return 'break_time_on'.tr;
    } else {
      return 'work_time_on'.tr;
    }
  }

  String getCounterTime() {
    if (controller.isOnLeave.value) {
      return 'on_leave'.tr;
    } else if (controller.isOnBreak.value) {
      return controller.remainingBreakTime.value;
    } else {
      return controller.totalWorkHours.value;
    }
  }
}
