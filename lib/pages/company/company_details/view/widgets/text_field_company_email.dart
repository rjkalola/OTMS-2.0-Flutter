import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/company_details/controller/company_details_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

class TextFieldCompanyEmail extends StatelessWidget {
  TextFieldCompanyEmail({super.key});

  final controller = Get.put(CompanyDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextFieldBorder(
        textEditingController: controller.companyEmailController.value,
        hintText: 'company_email_address'.tr,
        labelText: 'company_email_address'.tr,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onValueChange: (value) {},
        validator: MultiValidator([
          // RequiredValidator(errorText: 'required_field'.tr),
          EmailValidator(errorText: "enter_valid_email_address".tr),
        ]),
      ),
    );
  }
}
