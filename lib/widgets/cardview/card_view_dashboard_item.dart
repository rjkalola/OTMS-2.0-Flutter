import 'dart:ui';

import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/liiquide_glass_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/theme/theme_controller.dart';

class CardViewDashboardItem extends StatelessWidget {
  const CardViewDashboardItem(
      {super.key,
      required this.child,
      this.borderRadius,
      this.borderWidth,
      this.borderColor,
      this.margin,
      this.padding,
      this.alignment,
      this.blur,
      this.elevation,
      this.boxColor,
      this.shadowColor});

  final Widget child;
  final double? borderRadius, borderWidth, blur, elevation;
  final Color? borderColor, boxColor, shadowColor;
  final EdgeInsetsGeometry? margin, padding;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.find<ThemeController>().isDarkMode;

    final double effectiveBlur =
        blur ?? (Theme.of(context).platform == TargetPlatform.iOS ? 22 : 14);
    
    return Padding(
      padding: margin ?? EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: effectiveBlur,
            sigmaY: effectiveBlur,
          ),
          child: Container(
            alignment: alignment,
            padding: padding ?? EdgeInsets.zero,
            decoration: BoxDecoration(
              color: boxColor ??
                  LiquidGlassStyle.glassFill(context, isDark,
                      boxColor: boxColor),
              borderRadius: BorderRadius.circular(borderRadius ?? 20),
              border: Border.all(
                width: borderWidth ?? 1,
                color: borderColor ??
                    LiquidGlassStyle.glassBorder(context, isDark),
              ),
              boxShadow: LiquidGlassStyle.glassShadow(context, isDark),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/*class CardViewDashboardItem extends StatelessWidget {
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
      this.padding,
      this.alignment});

  final Widget child;
  final double? elevation, borderRadius, borderWidth;
  final Color? shadowColor, borderColor, boxColor;
  final EdgeInsetsGeometry? margin, padding;
  final AlignmentGeometry? alignment;

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
        alignment: alignment,
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
}*/
