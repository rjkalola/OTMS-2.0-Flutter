import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_phone_extension_widget.dart';

class PhoneExtensionTextFieldCompanySignUp extends StatelessWidget {
  PhoneExtensionTextFieldCompanySignUp({super.key});

  final controller = Get.put(CompanySignUpController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFieldPhoneExtensionWidget(
        mExtension: controller.mExtension.value,
        mFlag: controller.mFlag.value,
        onPressed: () {
          controller.showPhoneExtensionDialog();
        }));
  }
}
