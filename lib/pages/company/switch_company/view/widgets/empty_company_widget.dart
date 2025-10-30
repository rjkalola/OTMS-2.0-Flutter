import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyCompanyWidget extends StatelessWidget {
  EmptyCompanyWidget({super.key, required this.onPressedJoin});

  final VoidCallback onPressedJoin;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_outlined, // Company/office style icon
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'you_have_not_join_any_company'.tr,
            style: TextStyle(
              fontSize: 16,
              color: primaryTextColor_(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'please_create_or_join_a_company_to_continue'.tr,
            style: TextStyle(
              fontSize: 14,
              color: secondaryExtraLightTextColor_(context),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          PrimaryButton(
              width: 200,
              height: 40,
              buttonText: 'create_or_join'.tr,
              onPressed: onPressedJoin),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
