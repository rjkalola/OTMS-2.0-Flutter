import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_pages.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';

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
                if (!loginController.isOtpVerified.value) {
                  if (loginController.mOtpCode.value.length == 6) {
                    loginController.verifyOtpApi();
                  } else {
                    AppUtils.showSnackBarMessage('enter_otp'.tr);
                  }
                } else {
                  loginController.login();
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
