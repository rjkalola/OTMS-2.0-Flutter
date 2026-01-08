import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';

class PurchasingScreenTitleWidget extends StatelessWidget {
  final String title;

  const PurchasingScreenTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return TitleTextView(
      text: title,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    );
  }
}
