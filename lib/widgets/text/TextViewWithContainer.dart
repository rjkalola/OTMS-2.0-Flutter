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
      this.margin,
      this.width,
      this.height,
      this.alignment,
      this.onTap,
      this.maxLines,
      this.overflow,
      this.softWrap});

  final String text;
  final int? maxLines;
  final Color? fontColor, boxColor, borderColor;
  final double? fontSize, width, height, borderRadius, borderWidth;
  final FontWeight? fontWeight;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding, margin;
  final AlignmentGeometry? alignment;
  final GestureTapCallback? onTap;
  final TextOverflow? overflow;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        alignment: alignment,
        height: height,
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
          maxLines: maxLines,
          overflow: overflow,
          softWrap: softWrap,
          style: TextStyle(
            color: fontColor,
            fontSize: fontSize ?? 16,
            fontWeight: fontWeight ?? FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
