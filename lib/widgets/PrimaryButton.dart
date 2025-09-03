import 'package:flutter/material.dart';
import 'package:belcka/res/colors.dart';

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
  final int? maxLines;
  final TextOverflow? overflow;

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
      this.padding,
      this.maxLines,
      this.overflow});

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
          backgroundColor: color ?? defaultAccentColor_(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 45),
          ),
        ),
        child: Text(buttonText,
            maxLines: maxLines,
            overflow: overflow,
            style: TextStyle(
              color: fontColor ?? Colors.white,
              fontWeight: fontWeight ?? FontWeight.w500,
              fontSize: fontSize ?? 17,
            )),
      ),
    );
  }
}
