import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';

class OrderQuantityChangeButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double? width, height, fontSize;

  OrderQuantityChangeButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.width,
      this.height,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        height: width ?? 32,
        width: height ?? 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: normalTextFieldBorderColor_(context)),
        ),
        child: TitleTextView(
          text: text,
          fontSize: fontSize ?? 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
