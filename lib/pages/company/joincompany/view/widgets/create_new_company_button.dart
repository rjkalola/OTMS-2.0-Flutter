import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/company/joincompany/controller/join_company_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class CreateNewCompanyButton extends StatelessWidget {
  CreateNewCompanyButton({super.key});

  final controller = Get.put(JoinCompanyController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 16),
      child: SizedBox(
        width: double.infinity,
        child: PrimaryButton(
            buttonText: 'create_new_company'.tr,
            onPressed: () {
              if (!controller.isSelectTradeVisible.value) {
                var arguments = {AppConstants.intentKey.fromSignUpScreen: true};
                Get.toNamed(AppRoutes.companySignUpScreen,
                    arguments: arguments);
              }
              // controller.moveToCompanySignUp();
            }),
      ),
    );
  }
}
