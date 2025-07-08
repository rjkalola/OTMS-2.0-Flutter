import 'package:flutter/material.dart';
import 'package:otm_inventory/res/theme/app_colors.dart';
import 'package:otm_inventory/res/theme/app_theme_extension.dart';

class ThemeConfig {
  static bool isDarkMode = false;

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.black), // ← force icon color
      actionsIconTheme: IconThemeData(color: Colors.black),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textLight),
    ),
    extensions: <ThemeExtension<dynamic>>[
      const AppThemeExtension(
        dashboardBgColor: AppColors.dashBoardBgColor, // light version
      ),
    ],
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white), // ← force icon color
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textDark),
    ),
    extensions: <ThemeExtension<dynamic>>[
      const AppThemeExtension(
        dashboardBgColor: AppColors.dashBoardBgColorDark, // light version
      ),
    ],
  );
}
