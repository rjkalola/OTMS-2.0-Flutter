import 'dart:ffi';

import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final ValueChanged<bool?>? onValueChange;
  final mValue;
  final Color? color;

  const CustomCheckbox(
      {super.key,
      required this.onValueChange,
      required this.mValue,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      activeColor: color ?? Colors.green,
      value: mValue,
      onChanged: onValueChange,
    );
  }
}
