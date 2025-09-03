import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/shifts/create_shift/controller/create_shift_controller.dart';
import 'package:belcka/widgets/switch/custom_switch.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

class BreakTitleText extends StatelessWidget {
  BreakTitleText({
    super.key,
  });

  final controller = Get.put(CreateShiftController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 9, 12, 10),
        child: Row(
          children: [
            Expanded(
                child: TitleTextView(
              text: 'breaks'.tr,
              fontWeight: FontWeight.w500,
            )),
            CustomSwitch(
                onValueChange: (value) {
                  if (value) {
                    controller.addBreak();
                  } else {
                    controller.clearBreaks();
                  }
                },
                mValue: controller.breaksList.isNotEmpty),
          ],
        ),
      ),
    );
  }
}
