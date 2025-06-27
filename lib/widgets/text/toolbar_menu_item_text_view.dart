import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';

class ToolbarMenuItemTextView extends StatelessWidget {
  ToolbarMenuItemTextView(
      {super.key,
      required this.text,
      this.textColor,
      this.fontSize,
      this.fontWeight,
      this.padding,
      this.onTap});

  final String text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: padding ?? EdgeInsets.all(0),
        child: Text(
          text,
          style: TextStyle(
              color: textColor ?? defaultAccentColor,
              fontSize: fontSize ?? 16,
              fontWeight: fontWeight ?? FontWeight.w500),
        ),
      ),
    );
  }
}
