import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in2/controller/clock_in_controller.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';

class ContinueYesterdaysWorkButton extends StatelessWidget {
  ContinueYesterdaysWorkButton({super.key});

  final controller = Get.put(ClockInController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: SizedBox(
        width: double.infinity,
        child: PrimaryButton(
            buttonText: 'continue_yesterdays_work'.tr,
            borderRadius: 20,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            onPressed: () {
              controller.showSelectShiftDialog();
            }),
      ),
    );
  }
}
