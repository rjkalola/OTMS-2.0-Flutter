import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/controller/stop_shift_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class TotalHoursRow extends StatelessWidget {
  TotalHoursRow({super.key});

  final controller = Get.put(StopShiftController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CardViewDashboardItem(
          borderRadius: 14,
          margin: EdgeInsets.fromLTRB(14, 4, 14, 6),
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 7, 12, 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryTextView(
                  textAlign: TextAlign.start,
                  text: 'total_hours_'.tr,
                  color: primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                PrimaryTextView(
                  textAlign: TextAlign.start,
                  text: !controller.isEdited.value
                      ? (!StringHelper.isEmptyString(
                              controller.workLogInfo.value.workEndTime))
                          ? DateUtil.seconds_To_HH_MM(
                              controller.initialTotalWorkTime.value)
                          : "Working"
                      : DateUtil.seconds_To_HH_MM(
                          controller.updatedTotalWorkingTime.value),
                  color: !controller.isEdited.value
                      ? primaryTextColor
                      : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
          )),
    );
  }
}
