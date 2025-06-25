import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/controller/stop_shift_controller.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';

class StopShiftButton extends StatelessWidget {
  StopShiftButton({super.key});

  final controller = Get.put(StopShiftController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 16),
      child: PrimaryButton(
        buttonText: 'stop_shift'.tr,
        onPressed: () {
          controller.userStopWorkApi();
        },
        color: Colors.red,
      ),
    );
  }
}
