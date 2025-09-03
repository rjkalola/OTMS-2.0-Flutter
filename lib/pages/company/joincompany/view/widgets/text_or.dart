import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class TextOr extends StatelessWidget {
  const TextOr({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PrimaryTextView(
        text: 'or'.tr.toUpperCase(),
        color: primaryTextColor_(context),
        fontSize: 17,
      ),
    );
  }
}
