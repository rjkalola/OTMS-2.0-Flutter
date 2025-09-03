import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
        padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryTextView(
              text:
                  "1 Topham, Woodgreen, Ig8 12P  1 Topham, Woodgreen, Ig8 12P ",
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
            SizedBox(height: 10,),
            textRow('start_date'.tr, "07.05.2025"),
            SizedBox(height: 2,),
            textRow('end_date'.tr, "07.05.2026"),
            SizedBox(height: 2,),
            textRow('materials'.tr, "£2000"),
            SizedBox(height: 2,),
            textRow('price_work'.tr, "£1800"),
            SizedBox(height: 2,),
            textRow('day_work'.tr, "60 Hours (£ 1 100)"),
            SizedBox(height: 2,),
            textRow('total'.tr, "£4900")
          ],
        ));
  }

  Widget textRow(String title, String value) => TitleTextView(
        text: "$title: $value",
      );
}
