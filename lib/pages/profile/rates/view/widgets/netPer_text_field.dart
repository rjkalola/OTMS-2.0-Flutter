import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:belcka/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:belcka/widgets/textfield/text_field_underline_.dart';

class NetPerDayTextField extends StatelessWidget {
  NetPerDayTextField(
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
    return Obx(
      () => TextFieldUnderline(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textEditingController: controller.value,
          hintText: "",
          labelText: "(£)${'net_per_day'.tr}",
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          isReadOnly: isReadOnly,
          onValueChange: onValueChange,
          isEnabled: isEnabled,
          onPressed: () {},
          validator: MultiValidator([]),
          inputFormatters: <TextInputFormatter>[
            // for below version 2 use this
            DecimalTextInputFormatter(decimalRange: 2),
          ]),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({this.decimalRange = 2})
      : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Allow only numbers and decimal point
    final regex = RegExp(r'^\d*\.?\d*$');

    if (!regex.hasMatch(newValue.text)) {
      return oldValue;
    }

    // Check decimal places
    if (newValue.text.contains(".")) {
      final parts = newValue.text.split(".");
      if (parts.length > 1 && parts[1].length > decimalRange) {
        return oldValue;
      }
    }
    return newValue;
  }
}
