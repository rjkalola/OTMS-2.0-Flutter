import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/join_company_controller.dart';

class BackLogoJoinCompany extends StatelessWidget {
  BackLogoJoinCompany({super.key});

  final controller = Get.put(JoinCompanyController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 14, 16, 0),
      child: GestureDetector(
        onTap: () {
          controller.onBackPress();
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
      ),
    );
  }
}
