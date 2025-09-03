import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/work_log_request/controller/work_log_request_controller.dart';
import 'package:belcka/pages/check_in/work_log_request/view/widgets/start_shift_box.dart';
import 'package:belcka/utils/string_helper.dart';

import '../../../../../utils/app_constants.dart';

class StartStopBoxRow extends StatelessWidget {
  StartStopBoxRow({super.key});

  final controller = Get.put(WorkLogRequestController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Row(
          children: [
            StartShiftBox(
              title: 'start_shift'.tr,
              time: controller.startTime.value,
              address: "650, High road, 650, High road,",
              timePickerType:
                  AppConstants.dialogIdentifier.selectShiftStartTime,
              onTap: () {},
            ),
            SizedBox(
              width: 14,
            ),
            StartShiftBox(
              title: 'stop_shift'.tr,
              time: !StringHelper.isEmptyString(
                      controller.workLogInfo.value.workEndTime)
                  ? controller.stopTime.value
                  : controller.getCurrentTime(),
              address: "650, High road, 650, High road,",
              timePickerType: AppConstants.dialogIdentifier.selectShiftEndTime,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
