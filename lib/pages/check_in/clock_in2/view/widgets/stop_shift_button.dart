import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/clock_in/controller/clock_in_controller.dart';
import 'package:belcka/widgets/PrimaryButton.dart';

class StopShiftButton extends StatelessWidget {
  StopShiftButton({super.key});

  final controller = Get.put(ClockInController());

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
        width: double.infinity,
        child: PrimaryButton(
          buttonText: 'stop_shift'.tr,
          onPressed: () {
            if (controller.isChecking.value) {
              controller.showCheckOutWarningDialog();
            } else {
              controller.onClickWorkLogItem(controller.selectedWorkLogInfo!);
            }
            // controller.onClickStopShiftButton();
          },
          color: Color(0xffFF6464),
          fontWeight: FontWeight.w500,
          fontSize: 16,
          borderRadius: 15,
        ));
  }
}
