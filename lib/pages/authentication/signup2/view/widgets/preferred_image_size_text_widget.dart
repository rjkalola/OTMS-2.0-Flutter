import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';

class PreferredImageSizeTextWidget extends StatelessWidget {
  const PreferredImageSizeTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 0, left: 16, right: 16),
      child: Text('hint_upload_user_image'.tr,
          style: const TextStyle(
            color: secondaryLightTextColor,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          )),
    );
  }
}
