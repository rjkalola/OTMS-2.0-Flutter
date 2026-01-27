import 'package:belcka/widgets/textfield/text_field_underline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class UserCodeTextField extends StatelessWidget {
  final Rx<TextEditingController> controller;
  final bool isEnabled;
  final bool isReadOnly;
  final Function(String)? onChanged;

  UserCodeTextField({
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
        hintText: 'user_code'.tr,
        labelText: 'user_code'.tr,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        isReadOnly: isReadOnly,
        isEnabled: isEnabled,
        onPressed: () {},
        validator: MultiValidator([

        ]),
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this
          LengthLimitingTextInputFormatter(10),
        ]);
  }
}