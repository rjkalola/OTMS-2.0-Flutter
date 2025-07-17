import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../res/colors.dart';
import '../../../../widgets/text/PrimaryTextView.dart';

class PurchaseOrderCountItem extends StatelessWidget {
  PurchaseOrderCountItem(
      {super.key,
      required this.count,
      required this.title,
      required this.color,
      required this.iconPath,
      required this.iconColor});

  int count;
  Color color;
  String title;
  String iconPath;
  Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                width: 42,
                height: 42,
                iconPath,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(
            width: 9,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryTextView(
                  text: count.toString(),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: primaryTextColor_(context),
                ),
                PrimaryTextView(
                  softWrap: true,
                  text: title,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: primaryTextColor_(context),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
