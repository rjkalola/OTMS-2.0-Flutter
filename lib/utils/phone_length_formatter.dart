import 'package:flutter/services.dart';

class PhoneLengthFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    final maxLength = text.startsWith("0") ? 11 : 10;

    if (text.length > maxLength) {
      return oldValue;
    }

    return newValue;
  }
}
