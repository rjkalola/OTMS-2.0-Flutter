import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

class EmailTextFieldBorder extends StatelessWidget {
  EmailTextFieldBorder(
      {super.key,
      required this.controller,
      required this.hintText,
      this.labelText,
      this.isRequired,
      this.textInputAction,
      this.onValueChange,
      this.onFieldSubmitted,
      this.validator,
      this.maxLines,
      this.maxLength,
      this.keyboardType});

  // final controller = Get.put(CompanySignUpController());
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final int? maxLines, maxLength;
  final bool? isRequired;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onValueChange;
  final ValueChanged<String>? onFieldSubmitted;
  final MultiValidator? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFieldBorder(
      textEditingController: controller,
      hintText: hintText,
      labelText: labelText ?? hintText,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onValueChange: onValueChange,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator ??
          ((isRequired ?? false)
              ? MultiValidator([
                  RequiredValidator(errorText: 'required_field'.tr),
                  EmailValidator(errorText: "enter_valid_email_address".tr),
                ])
              : null),
    );
  }
}
