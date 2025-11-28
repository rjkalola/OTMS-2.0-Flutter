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

class TotalAllDayHoursRow extends StatelessWidget {
  TotalAllDayHoursRow({super.key});

  final controller = Get.put(StopShiftController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CardViewDashboardItem(
          borderRadius: 14,
          margin: EdgeInsets.fromLTRB(14, 4, 14, 14),
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 7, 12, 7),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryTextView(
                    textAlign: TextAlign.start,
                    text: "${'total_payable'.tr}:",
                    color: primaryTextColor_(context),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                PrimaryTextView(
                  textAlign: TextAlign.start,
                  text:
                      "${controller.currency.value}${controller.workLogInfo.value.totalDayEarnings ?? "0"}(${DateUtil.seconds_To_HH_MM(controller.workLogInfo.value.allWorklogsSeconds ?? 0)})",
                  color: primaryTextColor_(context),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
          )),
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
