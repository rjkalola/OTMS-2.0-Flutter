import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

class CompanyEmailTextField extends StatelessWidget {
  CompanyEmailTextField({super.key});

  final controller = Get.put(CompanySignUpController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: TextFieldBorder(
        textEditingController: controller.companyEmailController.value,
        hintText: 'business_email'.tr,
        labelText: 'business_email'.tr,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onValueChange: (value) {},
        onFieldSubmitted: (value) {
          FocusScope.of(context)
              .requestFocus(controller.focusNodePhone.value);
        },
        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
          EmailValidator(errorText: "enter_valid_email_address".tr),
        ]),
      ),
    );
  }
}
