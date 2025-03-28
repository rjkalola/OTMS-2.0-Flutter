import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_controller.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';

class StartWorkButton extends StatelessWidget {
  StartWorkButton({super.key});

  final controller = Get.put(ClockInController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 25, 16, 0),
      child: SizedBox(
        width: double.infinity,
        child: PrimaryButton(
            buttonText: 'start_work'.tr,
            color: Colors.green,
            borderRadius: 20,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            onPressed: () {
              controller.showSelectProjectDialog();
            }),
      ),
    );
  }
}
