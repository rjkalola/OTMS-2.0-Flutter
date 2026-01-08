import 'package:belcka/pages/profile/rates/controller/rates_controller.dart';
import 'package:belcka/widgets/textfield/text_field_underline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class NetPerDayTextField extends StatelessWidget {
  NetPerDayTextField({super.key});

  final controller = Get.put(RatesController());

  @override
  Widget build(BuildContext context) {
    return TextFieldUnderline(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textEditingController: controller.netPerDayController.value,
        hintText: "",
        labelText: "(£)${'net_per_day'.tr}",
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.done,
        isEnabled: !(controller.isRateRequested.value),
        onPressed: () {},
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 19,
        ),
        validator: MultiValidator([]),
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this
          DecimalTextInputFormatter(decimalRange: 2, maxValue: 100000),
        ]);
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;
  final double maxValue;

  DecimalTextInputFormatter({
    this.decimalRange = 2,
    this.maxValue = 100000,
  }) : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    // Allow only digits and decimal point
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
    //Check max value (100000)
    final value = double.tryParse(newValue.text);
    if (value != null && value > maxValue) {
      return oldValue;
    }
    return newValue;
  }
}
