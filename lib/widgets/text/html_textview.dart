import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../res/colors.dart';

class HtmlTextView extends StatelessWidget {
  HtmlTextView(
      {super.key,
      required this.text,
      this.color,
      this.fontWeight,
      this.fontSize,
      this.textAlign,
      this.softWrap});

  String text;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final bool? softWrap;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Html(data: text, style: {
      "body": Style(
        textAlign: textAlign ?? TextAlign.start,
        color: color ?? primaryTextColor_(context),
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: FontSize(fontSize ?? 14),
      ),
    });
  }
}
