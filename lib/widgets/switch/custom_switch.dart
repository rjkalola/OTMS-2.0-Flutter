import 'dart:ffi';

import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final ValueChanged<bool>? onValueChange;
  final mValue;
  final Color? activeColor, activeCircleColor;

  const CustomSwitch(
      {super.key,
      required this.onValueChange,
      required this.mValue,
      this.activeColor,
      this.activeCircleColor});

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: activeCircleColor ?? Colors.white,
      activeTrackColor: activeColor ?? Colors.green,
      value: mValue,
      onChanged: (value) {
        onValueChange!(value);
      },
    );
  }
}
