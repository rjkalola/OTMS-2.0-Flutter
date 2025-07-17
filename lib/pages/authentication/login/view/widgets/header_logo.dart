import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:get/get.dart';

class HeaderLogo extends StatelessWidget {
  HeaderLogo({super.key, this.isBackDisable});

  final bool? isBackDisable;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isBackDisable ?? false == false) {
          Get.back();
        }
      },
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 19,
            color: primaryTextColor_(context),
          ),
          SizedBox(
            width: 3,
          ),
          ImageUtils.setAssetsImage(
              path: Drawable.imgHeaderLogo, width: 100, height: 50)
        ],
      ),
    );
  }
}
