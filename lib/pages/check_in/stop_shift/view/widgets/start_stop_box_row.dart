import 'package:belcka/pages/check_in/stop_shift/controller/stop_shift_controller.dart';
import 'package:belcka/pages/check_in/stop_shift/view/widgets/current_hour_time.dart';
import 'package:belcka/pages/check_in/stop_shift/view/widgets/start_shift_box.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/app_constants.dart';
import '../../../../../utils/date_utils.dart';

class StartStopBoxRow extends StatelessWidget {
  StartStopBoxRow({super.key});

  final controller = Get.put(StopShiftController());

  @override
  Widget build(BuildContext context) {
    int status = controller.workLogInfo.value.status ?? 0;
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: IntrinsicHeight(
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
                      (status == 0 ||
                          status == AppConstants.status.rejected ||
                          status == AppConstants.status.unlock)) {
                    controller.showTimePickerDialog(
                        AppConstants.dialogIdentifier.selectShiftStartTime,
                        DateUtil.getDateTimeFromHHMM(
                            controller.startTime.value));
                  }
                },
              ),
              // SizedBox(
              //   width: 14,
              // ),
              CurrentHourTime(),
              StartShiftBox(
                title: 'stop_shift'.tr,
                time: !StringHelper.isEmptyString(
                        controller.workLogInfo.value.workEndTime)
                    ? controller.stopTime.value
                    : controller.getCurrentTime(),
                address: "650, High road, 650, High road,",
                timePickerType:
                    AppConstants.dialogIdentifier.selectShiftEndTime,
                onTap: () {
                  if (!StringHelper.isEmptyString(
                          controller.workLogInfo.value.workEndTime) &&
                      (status == 0 ||
                          status == AppConstants.status.rejected ||
                          status == AppConstants.status.unlock)) {
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
      ),
    );
  }

  Color getColor(BuildContext context) {
    Color color = primaryTextColor_(context);
    if (controller.isEdited.value) {
      color = Colors.red;
    } else {
      if (!StringHelper.isEmptyString(
          controller.workLogInfo.value.workEndTime)) {
        color = AppUtils.getStatusColor(
            controller.workLogInfo.value.requestStatus ?? 0);
      } else {
        color = defaultAccentColor_(context);
      }
    }
    return color;
  }
}
