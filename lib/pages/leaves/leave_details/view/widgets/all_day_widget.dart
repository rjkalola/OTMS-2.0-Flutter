import 'package:belcka/widgets/switch/custom_switch.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/leave_details_controller.dart';

class AllDayWidget extends StatelessWidget {
  final controller = Get.put(LeaveDetailsController());

  AllDayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(left: 20, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitleTextView(
              text: 'all_day'.tr,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            CustomSwitch(
                onValueChange: (value) {
                  print("value:" + value.toString());
                  controller.isSaveEnable.value = true;
                  controller.isAllDay.value = value;
                  controller.setTotalDays();
                },
                isDisable: true,
                mValue: controller.isAllDay.value)
          ],
        ),
      ),
    );
  }
}
