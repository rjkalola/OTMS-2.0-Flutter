import 'package:belcka/widgets/textfield/text_field_underline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class SearchTextFieldWidget extends StatelessWidget {
  final Rx<TextEditingController> controller;
  final bool isEnabled;
  final bool isReadOnly;
  final Function(String)? onChanged;

  SearchTextFieldWidget({
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
        hintText: "postcode_address".tr,
        labelText: "postcode_address".tr,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.search,
        isReadOnly: isReadOnly,
        isEnabled: isEnabled,
        onValueChange: (value) {},
        onPressed: () {},

        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
        ]),
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this

        ]);
  }
}