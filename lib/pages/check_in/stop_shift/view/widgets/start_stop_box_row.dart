import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/controller/stop_shift_controller.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/start_shift_box.dart';
import 'package:otm_inventory/utils/string_helper.dart';

class StartStopBoxRow extends StatelessWidget {
  StartStopBoxRow({super.key});

  final controller = Get.put(StopShiftController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Row(
        children: [
          StartShiftBox(
              title: 'start_shift'.tr,
              time: controller.changeFullDateToSortTime(
                  controller.workLogInfo.value.workStartTime),
              address: "650, High road, 650, High road,"),
          SizedBox(
            width: 14,
          ),
          StartShiftBox(
              title: 'stop_shift'.tr,
              time: !StringHelper.isEmptyString(
                      controller.workLogInfo.value.workEndTime)
                  ? controller.changeFullDateToSortTime(
                      controller.workLogInfo.value.workEndTime)
                  : controller.getCurrentTime(),
              address: "650, High road, 650, High road,"),
        ],
      ),
    );
  }
}
