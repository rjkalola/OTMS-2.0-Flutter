import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/profile/billing_info/view/widgets/title_text.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class TaxInfoView extends StatelessWidget {
  const TaxInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: CardViewDashboardItem(
          child: Container(
        padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(
              title: 'tax_info'.tr,
            )
          ],
        ),
      )),
    );
  }
}
