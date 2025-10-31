import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final ValueChanged<bool>? onValueChange;
  final mValue;
  final Color? activeColor, activeCircleColor;
  final bool? isDisable;

  const CustomSwitch(
      {super.key,
      required this.onValueChange,
      required this.mValue,
      this.activeColor,
      this.activeCircleColor,
      this.isDisable});

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      // activeColor: activeCircleColor ?? Colors.white,
      activeTrackColor: activeColor ?? Colors.green,
      value: mValue,
      onChanged: !(isDisable ?? false)
          ? (value) {
              onValueChange!(value);
            }
          : null,
    );
  }
}
