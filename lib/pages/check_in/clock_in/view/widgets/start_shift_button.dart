import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_controller.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';

class StartShiftButton extends StatelessWidget {
  StartShiftButton({super.key});

  final controller = Get.put(ClockInController());

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
        width: double.infinity,
        child: PrimaryButton(
          buttonText: 'start_shift'.tr,
          onPressed: () {
            controller.onClickStartShiftButton();
          },
          color: Colors.green,
          fontWeight: FontWeight.w500,
          fontSize: 16,
          borderRadius: 15,
        ));
  }
}
