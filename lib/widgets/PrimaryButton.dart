import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color? color;
  final double? borderRadius;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? fontColor;
  final double? elevation, width, height;
  final EdgeInsetsGeometry? padding;

  const PrimaryButton(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      this.color,
      this.borderRadius,
      this.fontWeight,
      this.fontSize,
      this.fontColor,
      this.elevation,
      this.width,
      this.height,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(0),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(width ?? double.infinity, height ?? 48),
          elevation: elevation ?? 0,
          backgroundColor: color ?? defaultAccentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 45),
          ),
        ),
        // color: color ?? defaultAccentColor,
        // elevation: 0,
        // height: 48,
        // splashColor: Colors.white.withAlpha(30),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(borderRadius ?? 45),
        // ),
        child: Text(buttonText,
            style: TextStyle(
              color: fontColor ?? Colors.white,
              fontWeight: fontWeight ?? FontWeight.w500,
              fontSize: fontSize ?? 17,
            )),
      ),
    );
  }
}
