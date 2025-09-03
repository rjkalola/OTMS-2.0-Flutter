import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/stop_shift/controller/stop_shift_controller.dart';
import 'package:belcka/pages/check_in/stop_shift/view/widgets/start_shift_box.dart';
import 'package:belcka/utils/string_helper.dart';

import '../../../../../utils/app_constants.dart';
import '../../../../../utils/date_utils.dart';

class StartStopBoxRow extends StatelessWidget {
  StartStopBoxRow({super.key});

  final controller = Get.put(StopShiftController());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () =>
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: Row(
              children: [
                StartShiftBox(
                  title: 'start_shift'.tr,
                  time: controller.startTime.value,
                  address: "650, High road, 650, High road,",
                  timePickerType:
                  AppConstants.dialogIdentifier.selectShiftStartTime,
                  onTap: () {
                    if (!StringHelper.isEmptyString(
                        controller.workLogInfo.value.workEndTime) &&
                        ((controller.workLogInfo.value.requestStatus ?? 0) ==
                            0 || (controller.workLogInfo.value.requestStatus ??
                            0) == AppConstants.status.rejected)) {
                      controller.showTimePickerDialog(
                          AppConstants.dialogIdentifier.selectShiftStartTime,
                          DateUtil.getDateTimeFromHHMM(
                              controller.startTime.value));
                    }
                  },
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
                  timePickerType: AppConstants.dialogIdentifier
                      .selectShiftEndTime,
                  onTap: () {
                    if (!StringHelper.isEmptyString(
                        controller.workLogInfo.value.workEndTime) &&
                        ((controller.workLogInfo.value.requestStatus ?? 0) ==
                            0 || (controller.workLogInfo.value.requestStatus ??
                            0) == AppConstants.status.rejected)) {
                      controller.showTimePickerDialog(
                          AppConstants.dialogIdentifier.selectShiftEndTime,
                          DateUtil.getDateTimeFromHHMM(
                              controller.stopTime.value));
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }
}
