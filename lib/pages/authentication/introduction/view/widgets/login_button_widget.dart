import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';

class LoginButtonWidget extends StatelessWidget {
  LoginButtonWidget({super.key});

  // final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
          child: PrimaryBorderButton(
            buttonText: 'log_in'.tr,
            textColor: defaultAccentColor,
            borderColor: defaultAccentColor,
            onPressed: () {
              print("login click");
              Get.toNamed(AppRoutes.loginScreen);
            },
          )),
    );
  }
}
