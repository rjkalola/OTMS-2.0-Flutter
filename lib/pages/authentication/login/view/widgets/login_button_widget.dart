import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_pages.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/PrimaryButton.dart';

import '../../controller/login_controller.dart';

class LoginButtonWidget extends StatelessWidget {
  LoginButtonWidget({super.key});

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: PrimaryButton(
            buttonText: 'continue'.tr,
            onPressed: () {
              if (loginController.isOtpViewVisible.value) {
                if (loginController.mOtpCode.value.length == 6) {
                  loginController.login();
                } else {
                  AppUtils.showSnackBarMessage('enter_otp'.tr);
                }
              } else {
                if (loginController.valid(false)) {
                  loginController.sendOtpApi();
                }
              }

              /*  loginController.login(
                  loginController.mExtension.value,
                  loginController.phoneController.value.text.toString().trim(),
                  false);*/

              /*if (loginController.isOtpViewVisible.value) {
                Get.toNamed(AppRoutes.joinCompanyScreen);
              } else {
                loginController.isOtpViewVisible.value = true;
              }*/
            },
          )),
    );
  }
}
