import 'package:belcka/widgets/switch/custom_switch.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/leave_details_controller.dart';

class TotalTimeRequested extends StatelessWidget {
  final controller = Get.put(LeaveDetailsController());

  TotalTimeRequested({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(left: 20, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitleTextView(
              text: 'total_time_requested'.tr,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            TitleTextView(
              text: "${controller.totalDays.value} ${'work_days'.tr}",
              fontSize: 17,
              fontWeight: FontWeight.w400,
            )
          ],
        ),
      ),
    );
  }
}
