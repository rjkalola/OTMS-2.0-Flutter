import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';

class PrimaryTextView extends StatelessWidget {
  const PrimaryTextView(
      {super.key,
      this.text,
      this.color,
      this.fontWeight,
      this.fontSize,
      this.textAlign,
      this.softWrap});

  final String? text;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final bool? softWrap;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(text ?? "",
        softWrap: softWrap ?? false,
        textAlign: textAlign ?? TextAlign.start,
        style: TextStyle(
          color: color ?? primaryTextColor,
          fontWeight: fontWeight ?? FontWeight.normal,
          fontSize: fontSize,
        ));
  }
}
