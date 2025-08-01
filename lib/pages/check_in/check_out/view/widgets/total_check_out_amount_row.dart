import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/check_out/controller/check_out_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class TotalCheckOutAmountRow extends StatelessWidget {
  TotalCheckOutAmountRow({super.key});

  final controller = Get.put(CheckOutController());

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !StringHelper.isEmptyString(
          controller.checkLogInfo.value.checkoutDateTime),
      child: CardViewDashboardItem(
          borderRadius: 14,
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 7, 12, 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryTextView(
                  textAlign: TextAlign.start,
                  text: "${'total_amount'.tr}:",
                  color: primaryTextColor_(context),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                PrimaryTextView(
                  textAlign: TextAlign.start,
                  text:
                      "£${controller.checkLogInfo.value.priceWorkTotalAmount ?? "0"}",
                  color: primaryTextColor_(context),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
          )),
    );
  }
}
