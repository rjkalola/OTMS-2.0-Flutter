import 'package:belcka/widgets/textfield/text_field_underline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class NINTextFieldBilling extends StatelessWidget {
  final Rx<TextEditingController> controller;
  final bool isEnabled;
  final bool isReadOnly;
  final Function(String)? onChanged;

  NINTextFieldBilling({
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
        hintText: "${'nin'.tr} (ex. AA111111A)",
        labelText: "${'nin'.tr} (ex. AA111111A)",
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