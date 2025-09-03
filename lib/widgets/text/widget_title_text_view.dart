import 'package:flutter/material.dart';
import 'package:belcka/res/colors.dart';

class WidgetTitleTextView extends StatelessWidget {
  const WidgetTitleTextView(
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
          color: color ?? primaryTextColor_(context),
          fontWeight: fontWeight ?? FontWeight.w400,
          fontSize: fontSize ?? 17,
        ));
  }
}
