import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/shifts/create_shift/controller/create_shift_controller.dart';
import 'package:belcka/widgets/switch/custom_switch.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class ShiftType extends StatelessWidget {
  ShiftType({super.key});

  final controller = Get.put(CreateShiftController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 9, 12, 10),
        child: Row(
          children: [
            Expanded(
                child: PrimaryTextView(
              fontSize: 16,
              text: 'does_it_have_price_work'.tr,
            )),
            CustomSwitch(
                onValueChange: (value) {
                  print("value:" + value.toString());
                  controller.isSaveEnable.value = true;
                  controller.shiftInfo.value.isPricework =
                      !(controller.shiftInfo.value.isPricework ?? false);
                  controller.shiftInfo.refresh();
                },
                mValue: controller.shiftInfo.value.isPricework ?? false),
          ],
        ),
      ),
    );
  }
}
