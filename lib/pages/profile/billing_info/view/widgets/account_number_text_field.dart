import 'package:belcka/widgets/textfield/text_field_underline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class AccountNumberTextFieldBilling extends StatelessWidget {
  final Rx<TextEditingController> controller;
  final bool isEnabled;
  final bool isReadOnly;
  final Function(String)? onChanged;

  AccountNumberTextFieldBilling({
    Key? key,
    required this.controller,
    this.isEnabled = true,
    this.isReadOnly = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldUnderline(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textEditingController: controller.value,
        hintText: 'account_number'.tr,
        labelText: 'account_number'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.done,
        isReadOnly: false,
        isEnabled: true,
        onPressed: () {},
        validator: MultiValidator([

        ]),
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this

        ]);
  }
}