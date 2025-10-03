import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:belcka/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:belcka/widgets/textfield/text_field_underline_.dart';

class NINTextFieldBilling extends StatelessWidget {
  NINTextFieldBilling(
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
        hintText: "${'nin'.tr} (ex. AA111111A)",
        labelText: "${'nin'.tr} (ex. AA111111A)",
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
