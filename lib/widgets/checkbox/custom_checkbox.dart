import 'dart:ffi';

import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final ValueChanged<bool?>? onValueChange;
  final mValue;

  const CustomCheckbox(
      {super.key, required this.onValueChange, required this.mValue});

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        activeColor: Colors.green, value: mValue, onChanged: onValueChange);
  }
}
