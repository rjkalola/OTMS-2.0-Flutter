import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';

class SignUpTextWidget extends StatelessWidget {
  const SignUpTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 28),
      child: Center(
        child: InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.signUp1Screen);
          },
          child: Text('sign_up'.tr,
              style: const TextStyle(
                color: defaultAccentColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              )),
        ),
      ),
    );
  }
}
