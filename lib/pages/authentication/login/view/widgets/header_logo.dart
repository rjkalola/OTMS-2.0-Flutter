import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:get/get.dart';

class HeaderLogo extends StatelessWidget {
  const HeaderLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 19,
            color: primaryTextColor,
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
