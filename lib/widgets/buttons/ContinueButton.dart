import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? color;
  final double? borderRadius;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? fontColor;

  const ContinueButton(
      {super.key,
      required this.onPressed,
      this.color,
      this.borderRadius,
      this.fontWeight,
      this.fontSize,
      this.fontColor});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        onPressed();
      },
      color: color ?? defaultAccentColor,
      elevation: 0,
      height: 48,
      splashColor: Colors.white.withAlpha(30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 45),
      ),
      child: Text('continue'.tr,
          style: TextStyle(
            color: fontColor ?? Colors.white,
            fontWeight: fontWeight ?? FontWeight.w500,
            fontSize: fontSize ?? 17,
          )),
    );
  }
}
