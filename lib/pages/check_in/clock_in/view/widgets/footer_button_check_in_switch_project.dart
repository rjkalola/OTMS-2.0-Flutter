import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_controller.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';

import '../../../../../utils/app_constants.dart';

class FooterButtonCheckInSwitchProject extends StatelessWidget {
  FooterButtonCheckInSwitchProject({super.key});

  final controller = Get.put(ClockInController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: (controller.workLogData.value.userIsWorking ?? false),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: PrimaryButton(
                  buttonText: 'switch_project'.tr,
                  onPressed: () {},
                  color: Color(0xffD5DDF2),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontColor: Color(0xff0353C1),
                  borderRadius: 10,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              controller.isChecking.value
                  ? Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: PrimaryButton(
                        buttonText: 'check_out_'.tr,
                        onPressed: () {
                          var arguments = {
                            AppConstants.intentKey.checkLogId:
                                controller.selectedCheckLogInfo?.id ?? 0,
                            AppConstants.intentKey.workLogId:
                                controller.selectedWorkLogInfo?.id ?? 0,
                            AppConstants.intentKey.projectId:
                                controller.selectedWorkLogInfo?.projectId ?? 0,
                            AppConstants.intentKey.isPriceWork:
                                controller.selectedWorkLogInfo?.isPricework ??
                                    false
                          };
                          controller.moveToScreen(
                              AppRoutes.checkOutScreen, arguments);
                        },
                        color: Color(0xffFF6464),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        borderRadius: 10,
                      ),
                    )
                  : Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: PrimaryButton(
                        buttonText: 'check_in_'.tr,
                        onPressed: () {
                          var arguments = {
                            AppConstants.intentKey.workLogId:
                                controller.selectedWorkLogInfo?.id ?? 0,
                            AppConstants.intentKey.projectId:
                                controller.selectedWorkLogInfo?.projectId ?? 0,
                            AppConstants.intentKey.isPriceWork:
                                controller.selectedWorkLogInfo?.isPricework ??
                                    false
                          };
                          controller.moveToScreen(
                              AppRoutes.checkInScreen, arguments);
                        },
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        borderRadius: 10,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
