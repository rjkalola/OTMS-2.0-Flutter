import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/work_log_request/controller/work_log_request_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/right_arrow_widget.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

import '../../../../../utils/app_constants.dart';

class TotalHoursRow extends StatelessWidget {
  TotalHoursRow({super.key});

  final controller = Get.put(WorkLogRequestController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CardViewDashboardItem(
          borderRadius: 14,
          margin: EdgeInsets.fromLTRB(14, 4, 14, 6),
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 7, 12, 7),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryTextView(
                    textAlign: TextAlign.start,
                    text: getHintText(controller.workLogInfo.value.status ?? 0),
                    color: primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                PrimaryTextView(
                  textAlign: TextAlign.start,
                  text: DateUtil.seconds_To_HH_MM((controller
                                  .workLogInfo.value.status ??
                              0) ==
                          AppConstants.status.pending
                      ? (controller.workLogInfo.value.payableWorkSeconds ?? 0)
                      : (controller.workLogInfo.value.totalRequestWorkSeconds ??
                          0)),
                  color: getHourTextColor(
                      controller.workLogInfo.value.status ?? 0),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                Visibility(
                    visible: (controller.workLogInfo.value.status ?? 0) ==
                        AppConstants.status.pending,
                    child: RightArrowWidget()),
                Visibility(
                    visible: (controller.workLogInfo.value.status ?? 0) ==
                        AppConstants.status.pending,
                    child: PrimaryTextView(
                      textAlign: TextAlign.start,
                      text: DateUtil.seconds_To_HH_MM(controller
                              .workLogInfo.value.totalRequestWorkSeconds ??
                          0),
                      color: pendingTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          )),
    );
  }

  String getHintText(int status) {
    if (status == AppConstants.status.rejected) {
      return "${'rejected_hours'.tr}:";
    } else if (status == AppConstants.status.approved) {
      return "${'approved_hours'.tr}:";
    } else {
      return "${'total_hours'.tr}:";
    }
  }

  Color getHourTextColor(int status) {
    if (status == AppConstants.status.rejected) {
      return rejectTextColor;
    } else if (status == AppConstants.status.approved) {
      return approvedTextColor;
    } else {
      return primaryTextColor;
    }
  }
}
