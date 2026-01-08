import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';

class PurchasingScreenItemValueWidget extends StatelessWidget {
  final String value;

  const PurchasingScreenItemValueWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      height: 36,
      child: CardViewDashboardItem(
          alignment: Alignment.center,
          borderRadius: 7,
          child: TitleTextView(
            text: value,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          )),
    );
  }
}
