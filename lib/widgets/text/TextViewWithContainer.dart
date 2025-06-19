import 'package:flutter/material.dart';

class TextViewWithContainer extends StatelessWidget {
  TextViewWithContainer(
      {super.key,
      this.boxColor,
      this.borderRadius,
      this.borderWidth,
      this.borderColor,
      this.boxShadow,
      required this.text,
      this.fontColor,
      this.fontSize,
      this.fontWeight,
      this.padding,
      this.margin});

  final String text;
  final Color? fontColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? boxColor;
  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding, margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: boxColor ?? Colors.transparent,
        boxShadow: boxShadow,
        border: Border.all(
            width: borderWidth ?? 0.6,
            color: borderColor ?? Colors.transparent),
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: fontColor,
            fontSize: fontSize ?? 16,
            fontWeight: fontWeight ?? FontWeight.w400),
      ),
    );
  }
}
