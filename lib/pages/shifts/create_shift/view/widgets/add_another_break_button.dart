import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/shifts/create_shift/controller/create_shift_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class AddAnotherBreakButton extends StatelessWidget {
  AddAnotherBreakButton({super.key});

  final controller = Get.put(CreateShiftController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.breaksList.isNotEmpty &&
            controller.breaksList.length < 5,
        child: GestureDetector(
          onTap: () {
            controller.addBreak();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
            child: PrimaryTextView(
              fontWeight: FontWeight.w500,
              color: defaultAccentColor,
              fontSize: 15,
              textAlign: TextAlign.right,
              text: "+ ${'add_another_break'.tr}",
            ),
          ),
        ),
      ),
    );
  }
}
