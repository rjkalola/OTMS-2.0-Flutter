import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';

import '../../../widgets/card_view.dart';
import '../../../widgets/text/PrimaryTextView.dart';

class DashboardStockCountItem extends StatelessWidget {
  DashboardStockCountItem({super.key, this.title, this.value, this.valueColor,required this.onPressed});

  String? title, value;
  Color? valueColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: CardView(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          PrimaryTextView(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: primaryTextColor,
          ),
          PrimaryTextView(
            text: value,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: valueColor,
          )
        ]),
      )),
    );
  }
}
