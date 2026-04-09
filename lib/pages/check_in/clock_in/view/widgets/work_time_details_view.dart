import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/clock_in/controller/clock_in_controller.dart';
import 'package:belcka/pages/check_in/clock_in/controller/clock_in_utils.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class WorkTimeDetailsView extends StatelessWidget {
  WorkTimeDetailsView({super.key});

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
            // color: controller.isOnBreak.value
            //     ? Color(0xffCE6700)
            //     : Color(0xff007AFF)),
            color: getBoxColor()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            PrimaryTextView(
              // text: controller.isOnBreak.value
              //     ? 'break_time_on'.tr
              //     : 'work_time_on'.tr,
              text: getStatusText(),
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            PrimaryTextView(
              // text: controller.isOnBreak.value
              //     ? controller.remainingBreakTime.value
              //     : controller.totalWorkHours.value,
              text: getCounterTime(),
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            /* Padding(
            padding: const EdgeInsets.fromLTRB(20, 3, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageUtils.setSvgAssetsImage(
                    path: Drawable.pinMapGoogleIcon,
                    width: 24,
                    height: 24,
                    color: Colors.white),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: PrimaryTextView(
                    text:
                        "650, High road, Essex ,London IG80PU 650, High road, Essex ,London IG80PU",
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),*/
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
