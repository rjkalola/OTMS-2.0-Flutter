import 'package:flutter/material.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class TitleText extends StatelessWidget {
  TitleText({super.key, this.title});

  String? title;

  @override
  Widget build(BuildContext context) {
    return PrimaryTextView(
      text: title ?? "",
      fontSize: 22,
      color: primaryTextColor_(context),
      fontWeight: FontWeight.w500,
    );
  }
}
