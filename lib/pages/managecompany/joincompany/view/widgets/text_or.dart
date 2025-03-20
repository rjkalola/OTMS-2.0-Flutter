import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class TextOr extends StatelessWidget {
  const TextOr({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PrimaryTextView(
        text: 'or'.tr.toUpperCase(),
        color: secondaryExtraLightTextColor,
        fontSize: 16,
      ),
    );
  }
}
