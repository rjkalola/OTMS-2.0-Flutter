import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';

class PurchasingScreenItemTextWidget extends StatelessWidget {
  final String text;
  final double? fontSize;

  const PurchasingScreenItemTextWidget(
      {super.key, required this.text, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: TitleTextView(
        text: text,
        fontSize: fontSize ?? 15,
        fontWeight: FontWeight.w400,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
