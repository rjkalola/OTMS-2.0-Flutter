import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/signup1/controller/signup1_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/PrimaryButton.dart';

class NextButtonWidget extends StatelessWidget {
  NextButtonWidget({super.key});

  final controller = Get.put(SignUp1Controller());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: PrimaryButton(
            buttonText: 'continue'.tr,
            onPressed: () {
              controller.onSubmitClick();
            /*  if (controller.isOtpViewVisible.value) {
                Get.toNamed(AppRoutes.joinCompanyScreen);
              } else {
                controller.isOtpViewVisible.value = true;
              }*/
            },
          )),
    );
  }
}
