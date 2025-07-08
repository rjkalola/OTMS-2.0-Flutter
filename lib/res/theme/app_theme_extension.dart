import 'package:flutter/material.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color dashboardBgColor;

  const AppThemeExtension({required this.dashboardBgColor});

  @override
  AppThemeExtension copyWith({Color? dashboardBg}) {
    return AppThemeExtension(
      dashboardBgColor: dashboardBgColor ?? this.dashboardBgColor,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      dashboardBgColor:
          Color.lerp(dashboardBgColor, other.dashboardBgColor, t)!,
    );
  }
}
