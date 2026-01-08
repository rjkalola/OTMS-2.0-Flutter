import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';

class PurchasingScreenItemTextWidget extends StatelessWidget {
  final String text;
  final double? fontSize;

  const PurchasingScreenItemTextWidget({super.key, required this.text,this.fontSize});

  @override
  Widget build(BuildContext context) {
    return TitleTextView(
      text: text,
      fontSize: fontSize??16,
      fontWeight: FontWeight.w400,
    );
  }
}
