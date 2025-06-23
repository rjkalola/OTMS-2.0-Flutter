import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:otm_inventory/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_underline_.dart';

class BankNameTextField extends StatelessWidget {
  BankNameTextField(
      {super.key,
        required this.controller,
        this.onValueChange,
        this.isReadOnly});

  final Rx<TextEditingController> controller;
  final ValueChanged<String>? onValueChange;
  final bool? isReadOnly;

  @override
  Widget build(BuildContext context) {
    return TextFieldUnderline(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textEditingController: controller.value,
        hintText: 'bank_name'.tr,
        labelText: 'bank_name'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        isReadOnly: isReadOnly,
        onValueChange: onValueChange,
        onPressed: () {},
        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
        ]),
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
        ]);
  }
}