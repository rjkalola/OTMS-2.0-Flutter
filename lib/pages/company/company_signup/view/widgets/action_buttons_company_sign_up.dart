import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/buttons/ContinueButton.dart';

import '../../../../../res/colors.dart';
import '../../../../../widgets/PrimaryBorderButton.dart';

class ActionButtonsCompanySignUp extends StatelessWidget {
  ActionButtonsCompanySignUp({super.key});

  final controller = Get.put(CompanySignUpController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Row(
        children: [
          /* Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: PrimaryBorderButton(
              buttonText: controller.fromSignUp.value ? 'skip'.tr : 'close'.tr,
              textColor: defaultAccentColor,
              borderColor: defaultAccentColor,
              borderRadius: 45,
              onPressed: () {
                Get.back();
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),*/
          Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: ContinueButton(onPressed: () {
                controller.onClickContinueButton();
                /*if (!controller.isOtpViewVisible.value) {
                  controller.isOtpViewVisible.value = true;
                } else {
                  Get.toNamed(AppRoutes.teamUsersCountInfoScreen);
                }*/
              })),
        ],
      ),
    );
  }
}
