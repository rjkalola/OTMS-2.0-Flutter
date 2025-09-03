import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/shifts/create_shift/controller/create_shift_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

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
              color: defaultAccentColor_(context),
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
