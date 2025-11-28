import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/stop_shift/controller/stop_shift_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class CurrentLogSummery extends StatelessWidget {
  CurrentLogSummery({super.key});

  final controller = Get.put(StopShiftController());

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
        borderRadius: 14,
        margin: EdgeInsets.fromLTRB(14, 4, 14, 12),
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Expanded(
                    child: PrimaryTextView(
                      textAlign: TextAlign.start,
                      text: "${'current_log_summery'.tr}:",
                      color: primaryTextColor_(context),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  PrimaryTextView(
                    textAlign: TextAlign.start,
                    text:
                        "${controller.currency.value}${controller.workLogInfo.value.allWorklogsAmount ?? "0"}(${DateUtil.seconds_To_HH_MM(controller.workLogInfo.value.allWorklogsSeconds ?? 0)})",
                    color: primaryTextColor_(context),
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  )
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Divider(),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Expanded(
                    child: PrimaryTextView(
                      textAlign: TextAlign.start,
                      text: "${'penalty'.tr}:",
                      color: primaryTextColor_(context),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  PrimaryTextView(
                    textAlign: TextAlign.start,
                    text: DateUtil.seconds_To_HH_MM(
                        controller.workLogInfo.value.allPenaltySeconds ?? 0),
                    color: Colors.red,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  )
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Divider(),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Expanded(
                    child: PrimaryTextView(
                      textAlign: TextAlign.start,
                      text: "${'check_in_'.tr}:",
                      color: primaryTextColor_(context),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  PrimaryTextView(
                    textAlign: TextAlign.start,
                    text:
                        "${controller.currency.value}${controller.workLogInfo.value.allChecklogAmount ?? "0"}(${controller.workLogInfo.value.allChecklogCount ?? 0})",
                    color: primaryTextColor_(context),
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  )
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Divider(),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Expanded(
                    child: PrimaryTextView(
                      textAlign: TextAlign.start,
                      text: "${'expense'.tr}:",
                      color: primaryTextColor_(context),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  PrimaryTextView(
                    textAlign: TextAlign.start,
                    text:
                        "${controller.currency.value}${controller.workLogInfo.value.allExpenseAmount ?? "0"}(${controller.workLogInfo.value.allExpenseCount ?? 0})",
                    color: primaryTextColor_(context),
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  )
                ],
              ),
              SizedBox(
                height: 6,
              ),
            ],
          ),
        ));
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
