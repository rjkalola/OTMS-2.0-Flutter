import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class TotalHoursRow extends StatelessWidget {
  const TotalHoursRow({super.key});

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
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
                text: "2:00",
                color: primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              )
            ],
          ),
        ));
  }
}
