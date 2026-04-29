import 'dart:io';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
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
    if (Platform.isAndroid){
      return Checkbox(
        activeColor: color ?? Colors.green,
        value: mValue,
        onChanged: onValueChange,
      );
    }
    else{
      return AdaptiveCheckbox(
        activeColor: color ?? Colors.green,
        value: mValue,
        onChanged: onValueChange,
      );
    }
  }
}
