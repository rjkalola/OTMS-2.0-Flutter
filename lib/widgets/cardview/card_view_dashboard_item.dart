import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';

import '../../res/theme/theme_controller.dart';

class CardViewDashboardItem extends StatelessWidget {
  const CardViewDashboardItem(
      {super.key,
      required this.child,
      this.elevation,
      this.borderRadius,
      this.borderWidth,
      this.shadowColor,
      this.borderColor,
      this.boxColor,
      this.margin,
      this.padding});

  final Widget child;
  final double? elevation, borderRadius, borderWidth;
  final Color? shadowColor, borderColor, boxColor;
  final EdgeInsetsGeometry? margin, padding;

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.find<ThemeController>().isDarkMode;
    return Card(
      margin: margin,
      elevation: elevation ?? 2,
      shadowColor: shadowColor ?? shadowColor_(context),
      color: boxColor ?? backgroundColor_(context),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 20)),
      child: Container(
        padding: padding ?? EdgeInsets.all(0),
        decoration: BoxDecoration(
            color: boxColor ?? backgroundColor_(context),
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius ?? 20),
            ),
            border: Border.all(
                width: borderWidth ?? 1,
                color: borderColor ??
                    (isDark
                        ? Color(AppUtils.haxColor("#1A1A1A"))
                        : Color(AppUtils.haxColor("#EEEEEE"))))),
        child: child,
      ),
    );
  }
}
