import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';

class HeaderTitleNoteTextWidget extends StatelessWidget {
  const HeaderTitleNoteTextWidget(
      {super.key, required this.title, this.fontSize, this.textAlign});

  final String title;
  final double? fontSize;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4, left: 20, right: 20),
      child: Text(title,
          textAlign: textAlign,
          style: TextStyle(
            color: primaryTextColor_(context),
            fontSize: fontSize ?? 24,
            fontWeight: FontWeight.bold,
          )),
    );
  }
}
