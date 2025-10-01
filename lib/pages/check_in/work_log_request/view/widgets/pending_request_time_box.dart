import 'package:belcka/pages/check_in/work_log_request/controller/work_log_request_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PendingRequestTimeBox extends StatelessWidget {
  PendingRequestTimeBox({super.key});

  final controller = Get.put(WorkLogRequestController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: CardViewDashboardItem(
                  child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 6,
                      bottom: 6,
                    ),
                    decoration: AppUtils.getGrayBorderDecoration(
                        color: backgroundColor_(context),
                        borderColor: ThemeConfig.isDarkMode
                            ? Color(0xFF424242)
                            : Colors.grey.shade400,
                        boxShadow: [
                          AppUtils.boxShadow(shadowColor_(context), 6)
                        ],
                        radius: 45),
                    child: PrimaryTextView(
                      textAlign: TextAlign.center,
                      text: 'actual_shift'.tr,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: primaryTextColor_(context),
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  PrimaryTextView(
                    text: controller.workLogInfo.value.oldStartTime != null
                        ? controller.changeFullDateToSortTime(
                            controller.workLogInfo.value.oldStartTime)
                        : "",
                    color: primaryTextColor_(context),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  PrimaryTextView(
                    text: controller.workLogInfo.value.oldEndTime != null
                        ? controller.changeFullDateToSortTime(
                            controller.workLogInfo.value.oldEndTime)
                        : "",
                    color: primaryTextColor_(context),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 14,
                  ),
                ],
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              child: Icon(
                Icons.keyboard_arrow_right_outlined,
                size: 26,
                color: Colors.grey,
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: CardViewDashboardItem(
                  child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 6,
                      bottom: 6,
                    ),
                    decoration: AppUtils.getGrayBorderDecoration(
                        color: backgroundColor_(context),
                        borderColor: Colors.orange,
                        boxShadow: [
                          AppUtils.boxShadow(shadowColor_(context), 6)
                        ],
                        radius: 45),
                    child: PrimaryTextView(
                      textAlign: TextAlign.center,
                      text: 'requested_shift'.tr,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  PrimaryTextView(
                    text: controller.startTime.value,
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  PrimaryTextView(
                    text: !StringHelper.isEmptyString(
                            controller.workLogInfo.value.workEndTime)
                        ? controller.stopTime.value
                        : controller.getCurrentTime(),
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 14,
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
