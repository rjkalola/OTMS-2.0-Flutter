import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/managecompany/company_details/controller/company_details_controller.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_phone_extension_widget.dart';

class TextFieldPhoneExtension extends StatelessWidget {
  TextFieldPhoneExtension({super.key});

  final controller = Get.put(CompanyDetailsController());

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
