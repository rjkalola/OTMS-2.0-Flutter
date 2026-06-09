import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormValidationBanner extends StatelessWidget {
  const FormValidationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'please_fix_highlighted_fields'.tr,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: rejectTextColor_(context),
        ),
      ),
    );
  }
}
