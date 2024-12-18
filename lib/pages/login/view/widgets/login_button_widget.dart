import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';

import '../../controller/login_controller.dart';

class LoginButtonWidget extends StatelessWidget {
  LoginButtonWidget({super.key});

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 14),
          child: PrimaryBorderButton(
            buttonText: 'login_with_otp'.tr,
            textColor: defaultAccentColor,
            borderColor: defaultAccentColor,
            onPressed: () {
              loginController.login(
                  loginController.mExtension.value,
                  loginController.phoneController.value.text.toString().trim(),
                  false);
            },
          )),
    );
  }
}
