import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';

class LoginButtonWidget extends StatelessWidget {
  LoginButtonWidget({super.key});

  // final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 220,
        child: PrimaryButton(
            buttonText: 'login'.tr,
            onPressed: () {
              Get.toNamed(AppRoutes.loginScreen);
            }));
  }
}
