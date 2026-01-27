import 'package:flutter/material.dart';
import 'package:belcka/res/colors.dart';

class OrdersTitleTextView extends StatelessWidget {
  const OrdersTitleTextView(
      {super.key,
        this.text,
        this.color,
        this.fontWeight,
        this.fontSize,
        this.textAlign,
        this.softWrap,
        this.maxLine,
      this.overflow});

  final String? text;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final bool? softWrap;
  final TextAlign? textAlign;
  final int? maxLine;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(text ?? "",
        softWrap: softWrap ?? true,
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLine,
        overflow: overflow,
        style: TextStyle(
          color: color ?? primaryTextColor_(context),
          fontWeight: fontWeight ?? FontWeight.w400,
          fontSize: fontSize ?? 15,
        ));
  }
}
