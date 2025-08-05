import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';

import '../../../clock_in/controller/clock_in_controller.dart';

class StartShiftButtonRow extends StatelessWidget {
  StartShiftButtonRow({super.key});

  final controller = Get.put(ClockInController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: PrimaryButton(
              buttonText: 'start_shift'.tr,
              onPressed: () {
                controller.onClickStartShiftButton();
              },
              color: Colors.green,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              borderRadius: 45,
            ),
          ),
          Visibility(
            visible: (controller.workLogData.value.projectId ?? 0) != 0,
            child: const SizedBox(
              width: 10,
            ),
          ),
          Visibility(
            visible: (controller.workLogData.value.projectId ?? 0) != 0,
            child: Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: PrimaryButton(
                buttonText: controller.workLogData.value.projectName ?? "",
                onPressed: () {
                  controller.userStartWorkApi();
                },
                color: defaultAccentColor_(context),
                fontWeight: FontWeight.w500,
                fontSize: 16,
                borderRadius: 45,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
