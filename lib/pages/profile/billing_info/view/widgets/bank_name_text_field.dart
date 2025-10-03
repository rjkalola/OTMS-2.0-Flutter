import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/widgets/textfield/text_field_underline_.dart';

class BankNameTextFieldBilling extends StatelessWidget {
  BankNameTextFieldBilling(
      {super.key,
        required this.controller,
        this.onValueChange,
        this.isReadOnly,
        this.isEnabled});

  final Rx<TextEditingController> controller;
  final ValueChanged<String>? onValueChange;
  final bool? isReadOnly;
  final bool? isEnabled;

  @override
  Widget build(BuildContext context) {
    return TextFieldUnderline(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textEditingController: controller.value,
        hintText: 'bank_name'.tr,
        labelText: 'bank_name'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.done,
        isReadOnly: isReadOnly,
        isEnabled: isEnabled,
        onValueChange: onValueChange,
        onPressed: () {},
        validator: MultiValidator([

        ]),
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this
        ]);
  }
}