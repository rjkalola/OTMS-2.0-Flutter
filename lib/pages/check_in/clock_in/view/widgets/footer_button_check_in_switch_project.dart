import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/clock_in/controller/clock_in_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/PrimaryButton.dart';

import '../../../../../utils/app_constants.dart';

class FooterButtonCheckInSwitchProject extends StatelessWidget {
  FooterButtonCheckInSwitchProject({super.key});

  final controller = Get.put(ClockInController());

  void _onSwitchProjectPressed() {
    var arguments = {
      AppConstants.intentKey.switchProject: true,
      AppConstants.intentKey.workLogId: controller.selectedWorkLogInfo?.id ?? 0,
    };
    controller.onClickStartShiftButton(arguments: arguments);
  }

  void _onStopShiftPressed() {
    if (controller.isChecking.value) {
      controller.showCheckOutWarningDialog();
    } else {
      controller.onClickWorkLogItem(controller.selectedWorkLogInfo!);
    }

    // if (controller.isChecking.value) return;
    // final selectedWorkLog = controller.selectedWorkLogInfo;
    // if (selectedWorkLog == null) return;
    // controller.onClickWorkLogItem(selectedWorkLog);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isWorking = controller.workLogData.value.userIsWorking ?? false;

      return Container(
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: isWorking
                ? Row(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: PrimaryButton(
                          buttonText: 'stop_shift'.tr,
                          onPressed: _onStopShiftPressed,
                          color: controller.isChecking.value
                              ? const Color(0xff9E9E9E)
                              : const Color(0xffFF6464),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 52,
                        height: 52,
                        child: Material(
                          color: const Color(0xff3F73EA),
                          borderRadius: BorderRadius.circular(26),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(26),
                            onTap: _onSwitchProjectPressed,
                            child: const Center(
                              child: Icon(
                                Icons.swap_horiz_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if((controller.workLogData.value.isCheckIn ??
                          false))
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: controller.isChecking.value
                            ? PrimaryButton(
                                buttonText: 'check_out_'.tr,
                                onPressed: () {
                                  controller.onCLickCheckOutButton();
                                },
                                color: const Color(0xffFF6464),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              )
                            : PrimaryButton(
                                buttonText: 'check_in_'.tr,
                                onPressed: () {
                                  controller.onCLickCheckInButton();
                                },
                                color:
                                    (controller.workLogData.value.isCheckIn ??
                                            false)
                                        ? Colors.green
                                        : Color(0xff9E9E9E),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                      ),
                    ],
                  )
                : PrimaryButton(
                    buttonText: 'start_shift'.tr,
                    onPressed: () {
                      controller.userBillingInfoValidationAPI(
                          isStartWorkClick: true);
                    },
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
          ),
        ),
      );
    });
  }
}
