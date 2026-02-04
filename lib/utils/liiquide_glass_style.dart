import 'dart:ui';

import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';

class LiquidGlassStyle {
  static Color glassFill(BuildContext context, bool isDark, {Color? boxColor}) {
    return boxColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.06)
            : backgroundColor_(context).withValues(alpha: 0.75));
  }

  static Color glassBorder(BuildContext context, bool isDark) {
    return isDark
        ? Colors.white.withValues(alpha: 0.15)
        : dividerColor_(context);
  }

  static List<BoxShadow> glassShadow(BuildContext context, bool isDark) {
    return [
      BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.45)
            : shadowColor_(context).withValues(alpha: 0.6),
        blurRadius: isDark ? 24 : 16,
        offset: const Offset(0, 8),
      ),
    ];
  }
}
