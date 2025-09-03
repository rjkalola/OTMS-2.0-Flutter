import 'package:flutter/material.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/app_colors.dart';
import 'package:belcka/res/theme/app_theme_extension.dart';

class ThemeConfig {
  static bool isDarkMode = false;

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.defaultAccentColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
      foregroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.black), // ← force icon color
      actionsIconTheme: IconThemeData(color: Colors.black),
    ),
    // textTheme: const TextTheme(
    //   bodyLarge: TextStyle(color: AppColors.textLight),
    // ),
    extensions: <ThemeExtension<dynamic>>[
      const AppThemeExtension(
          dashBoardBgColor: AppColors.dashBoardBgColor,
          // light version
          primaryTextColor: AppColors.primaryTextColor,
          primaryTextColorLight: AppColors.primaryTextColorLight,
          secondaryTextColor: AppColors.secondaryTextColor,
          secondaryLightTextColor: AppColors.secondaryLightTextColor,
          secondaryExtraLightTextColor: AppColors.secondaryExtraLightTextColor,
          defaultAccentColor: AppColors.defaultAccentColor,
          defaultAccentLightColor: AppColors.defaultAccentLightColor,
          backgroundColor: AppColors.backgroundColor,
          titleBgColor: AppColors.titleBgColor,
          snackBarColor: AppColors.snackBarColor,
          dividerColor: AppColors.dividerColor,
          bottomTabbackgroundColor: AppColors.bottomTabbackgroundColor,
          hintColor: AppColors.hintColor,
          normalTextFieldBorderColor: AppColors.normalTextFieldBorderColor,
          focusedTextFieldBorderColor: AppColors.focusedTextFieldBorderColor,
          normalTextFieldBorderDarkColor:
              AppColors.normalTextFieldBorderDarkColor,
          focusedTextFieldBorderDarkColor:
              AppColors.focusedTextFieldBorderDarkColor,
          pendingTextColor: AppColors.pendingTextColor,
          approvedTextColor: AppColors.approvedTextColor,
          rejectTextColor: AppColors.rejectTextColor,
          shadowColor: AppColors.shadowColor,
          lightGreyColor: AppColors.lightGreyColor),
    ],
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.defaultAccentColorDark,
    scaffoldBackgroundColor: AppColors.backgroundColorDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundColorDark,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white), // ← force icon color
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),
    // textTheme: const TextTheme(
    //   bodyLarge: TextStyle(color: AppColors.textDark),
    // ),
    extensions: <ThemeExtension<dynamic>>[
      const AppThemeExtension(
          dashBoardBgColor: AppColors.dashBoardBgColorDark,
          // light version
          primaryTextColor: AppColors.primaryTextColorDark,
          primaryTextColorLight: AppColors.primaryTextColorLightDark,
          secondaryTextColor: AppColors.secondaryTextColorDark,
          secondaryLightTextColor: AppColors.secondaryLightTextColorDark,
          secondaryExtraLightTextColor:
              AppColors.secondaryExtraLightTextColorDark,
          defaultAccentColor: AppColors.defaultAccentColorDark,
          defaultAccentLightColor: AppColors.defaultAccentLightColorDark,
          backgroundColor: AppColors.backgroundColorDark,
          titleBgColor: AppColors.titleBgColorDark,
          snackBarColor: AppColors.snackBarColorDark,
          dividerColor: AppColors.dividerColorDark,
          bottomTabbackgroundColor: AppColors.bottomTabBackgroundColorDark,
          hintColor: AppColors.hintColorDark,
          normalTextFieldBorderColor: AppColors.normalTextFieldBorderColorDark,
          focusedTextFieldBorderColor:
              AppColors.focusedTextFieldBorderColorDark,
          normalTextFieldBorderDarkColor:
              AppColors.normalTextFieldBorderDarkColorDark,
          focusedTextFieldBorderDarkColor:
              AppColors.focusedTextFieldBorderDarkColorDark,
          pendingTextColor: AppColors.pendingTextColorDark,
          approvedTextColor: AppColors.approvedTextColorDark,
          rejectTextColor: AppColors.rejectTextColorDark,
          shadowColor: AppColors.shadowColorDark,
          lightGreyColor: AppColors.lightGreyColorDark),
    ],
  );
}
