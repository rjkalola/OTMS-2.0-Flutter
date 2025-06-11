import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';

class TitleTextView extends StatelessWidget {
  const TitleTextView(
      {super.key,
      this.text,
      this.color,
      this.fontWeight,
      this.fontSize,
      this.textAlign,
      this.softWrap,
      this.maxLine});

  final String? text;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final bool? softWrap;
  final TextAlign? textAlign;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    return Text(text ?? "",
        softWrap: softWrap ?? true,
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLine,
        style: TextStyle(
          color: color ?? primaryTextColor,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontSize: fontSize ?? 16,
        ));
  }
}
