import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';

class UploadPhotoTextWidget extends StatelessWidget {
  const UploadPhotoTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 0, left: 16, right: 16),
      child: Text('upload_photo_capital'.tr,
          style: const TextStyle(
            color: defaultAccentColor,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          )),
    );
  }
}
