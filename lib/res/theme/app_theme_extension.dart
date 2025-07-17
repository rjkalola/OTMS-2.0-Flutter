import 'package:flutter/material.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color dashBoardBgColor,
      primaryTextColor,
      primaryTextColorLight,
      secondaryTextColor,
      secondaryLightTextColor,
      secondaryExtraLightTextColor,
      defaultAccentColor,
      defaultAccentLightColor,
      backgroundColor,
      titleBgColor,
      snackBarColor,
      dividerColor,
      bottomTabbackgroundColor,
      hintColor,
      normalTextFieldBorderColor,
      focusedTextFieldBorderColor,
      normalTextFieldBorderDarkColor,
      focusedTextFieldBorderDarkColor,
      pendingTextColor,
      approvedTextColor,
      rejectTextColor,
      shadowColor;

  const AppThemeExtension(
      {required this.dashBoardBgColor,
      required this.primaryTextColor,
      required this.primaryTextColorLight,
      required this.secondaryTextColor,
      required this.secondaryLightTextColor,
      required this.secondaryExtraLightTextColor,
      required this.defaultAccentColor,
      required this.defaultAccentLightColor,
      required this.backgroundColor,
      required this.titleBgColor,
      required this.snackBarColor,
      required this.dividerColor,
      required this.bottomTabbackgroundColor,
      required this.hintColor,
      required this.normalTextFieldBorderColor,
      required this.focusedTextFieldBorderColor,
      required this.normalTextFieldBorderDarkColor,
      required this.focusedTextFieldBorderDarkColor,
      required this.pendingTextColor,
      required this.approvedTextColor,
      required this.rejectTextColor,
      required this.shadowColor});

  @override
  AppThemeExtension copyWith({Color? dashboardBg}) {
    return AppThemeExtension(
        dashBoardBgColor: dashBoardBgColor,
        primaryTextColor: primaryTextColor,
        primaryTextColorLight: primaryTextColorLight,
        secondaryTextColor: secondaryTextColor,
        secondaryLightTextColor: secondaryLightTextColor,
        secondaryExtraLightTextColor: secondaryExtraLightTextColor,
        defaultAccentColor: defaultAccentColor,
        defaultAccentLightColor: defaultAccentLightColor,
        backgroundColor: backgroundColor,
        titleBgColor: titleBgColor,
        snackBarColor: snackBarColor,
        dividerColor: dividerColor,
        bottomTabbackgroundColor: bottomTabbackgroundColor,
        hintColor: hintColor,
        normalTextFieldBorderColor: normalTextFieldBorderColor,
        focusedTextFieldBorderColor: focusedTextFieldBorderColor,
        normalTextFieldBorderDarkColor: normalTextFieldBorderDarkColor,
        focusedTextFieldBorderDarkColor: focusedTextFieldBorderDarkColor,
        pendingTextColor: pendingTextColor,
        approvedTextColor: approvedTextColor,
        rejectTextColor: approvedTextColor,
        shadowColor: shadowColor);
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      dashBoardBgColor:
          Color.lerp(dashBoardBgColor, other.dashBoardBgColor, t)!,
      primaryTextColor:
          Color.lerp(primaryTextColor, other.primaryTextColor, t)!,
      primaryTextColorLight:
          Color.lerp(primaryTextColorLight, other.primaryTextColorLight, t)!,
      secondaryTextColor:
          Color.lerp(secondaryTextColor, other.secondaryTextColor, t)!,
      secondaryLightTextColor: Color.lerp(
          secondaryLightTextColor, other.secondaryLightTextColor, t)!,
      secondaryExtraLightTextColor: Color.lerp(
          secondaryExtraLightTextColor, other.secondaryExtraLightTextColor, t)!,
      defaultAccentColor:
          Color.lerp(defaultAccentColor, other.defaultAccentColor, t)!,
      defaultAccentLightColor: Color.lerp(
          defaultAccentLightColor, other.defaultAccentLightColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      titleBgColor: Color.lerp(titleBgColor, other.titleBgColor, t)!,
      snackBarColor: Color.lerp(snackBarColor, other.snackBarColor, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      bottomTabbackgroundColor: Color.lerp(
          bottomTabbackgroundColor, other.bottomTabbackgroundColor, t)!,
      hintColor: Color.lerp(hintColor, other.hintColor, t)!,
      normalTextFieldBorderColor: Color.lerp(
          normalTextFieldBorderColor, other.normalTextFieldBorderColor, t)!,
      focusedTextFieldBorderColor: Color.lerp(
          focusedTextFieldBorderColor, other.focusedTextFieldBorderColor, t)!,
      normalTextFieldBorderDarkColor: Color.lerp(normalTextFieldBorderDarkColor,
          other.normalTextFieldBorderDarkColor, t)!,
      focusedTextFieldBorderDarkColor: Color.lerp(
          focusedTextFieldBorderDarkColor,
          other.focusedTextFieldBorderDarkColor,
          t)!,
      pendingTextColor:
          Color.lerp(pendingTextColor, other.pendingTextColor, t)!,
      approvedTextColor:
          Color.lerp(approvedTextColor, other.approvedTextColor, t)!,
      rejectTextColor: Color.lerp(rejectTextColor, other.rejectTextColor, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
    );
  }
}
