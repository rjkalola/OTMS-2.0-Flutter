import 'package:flutter/material.dart';

import '../res/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color? color;
  final double? borderRadius;
  final FontWeight? fontWeight;
  final double? fontSize;

  const PrimaryButton(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      this.color,
      this.borderRadius,
      this.fontWeight,
      this.fontSize});

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
        borderRadius: BorderRadius.circular(borderRadius ?? 4),
      ),
      child: Text(buttonText,
          style: TextStyle(
            color: Colors.white,
            fontWeight: fontWeight ?? FontWeight.w600,
            fontSize: fontSize ?? 15,
          )),
    );
  }
}
