import 'package:belcka/widgets/textfield/text_field_underline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';


class SortCodeTextFieldKeyboard extends StatelessWidget {
  final Rx<TextEditingController> controller;
  final bool isEnabled;
  final bool isReadOnly;
  final FocusNode focusNode;
  final Function(String)? onChanged;

  SortCodeTextFieldKeyboard({
    Key? key,
    required this.controller,
    this.isEnabled = true,
    this.isReadOnly = false,
    this.onChanged,
    required this.focusNode
  }) : super(key: key);


  @override
  @override
  Widget build(BuildContext context) {
    return TextFieldUnderline(
        focusNode: focusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textEditingController: controller.value,
        hintText:"12-34-56",
        labelText: 'sort_code'.tr,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        isReadOnly: isReadOnly,
        onPressed: () {},
        validator: MultiValidator([

        ]),
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this
          FilteringTextInputFormatter.digitsOnly,
          HyphenFormatter(),
        ]);
  }
}

class HyphenFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 6; i++) {
      buffer.write(digits[i]);
      if ((i == 1 || i == 3) && i != digits.length - 1) {
        buffer.write('-');
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}