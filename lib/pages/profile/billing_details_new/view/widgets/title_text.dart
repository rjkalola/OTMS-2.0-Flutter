import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class TitleText extends StatelessWidget {
  TitleText({super.key, this.title});

  String? title;

  @override
  Widget build(BuildContext context) {
    return PrimaryTextView(
      text: title ?? "",
      fontSize: 22,
      color: primaryTextColor,
      fontWeight: FontWeight.w500,
    );
  }
}
