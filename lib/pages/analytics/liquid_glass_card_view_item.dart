import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../res/theme/theme_controller.dart';

class LiquidGlassCardViewItem extends StatelessWidget {
  const LiquidGlassCardViewItem({
    super.key,
    required this.child,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.margin,
    this.padding,
    this.alignment,
    this.blur,
    this.boxShadow,
    this.enableNoise = true,
  });

  final Widget child;
  final double? borderRadius;
  final double? borderWidth;
  final double? blur;
  final Color? borderColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final List<BoxShadow>? boxShadow;
  final bool enableNoise;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.find<ThemeController>().isDarkMode;

    final double radius = borderRadius ?? 30;
    final double effectiveBlur =
        blur ?? (Theme.of(context).platform == TargetPlatform.iOS ? 24 : 16);

    return Padding(
      padding: margin ?? const EdgeInsets.all(6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: effectiveBlur,
            sigmaY: effectiveBlur,
          ),
          child: Container(
            alignment: alignment,
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: LiquidGlassStyle.glassGradient(isDark),
              border: Border.all(
                width: borderWidth ?? 1.2,
                color: borderColor ??
                    LiquidGlassStyle.glassBorder(isDark),
              ),
              boxShadow:
              boxShadow ?? LiquidGlassStyle.glassShadow(isDark),
            ),
            child: Stack(
              children: [
                /// 🍎 Apple-style micro noise
                if (enableNoise)
                  const Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: GlassNoisePainter(),
                      ),
                    ),
                  ),

                /// 🔹 Actual content
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LiquidGlassStyle {
  static LinearGradient glassGradient(bool isDark) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
        Colors.white.withOpacity(0.10),
        Colors.white.withOpacity(0.03),
      ]
          : [
        Colors.white.withOpacity(0.55),
        Colors.white.withOpacity(0.25),
      ],
    );
  }

  static Color glassBorder(bool isDark) {
    return isDark
        ? Colors.white.withOpacity(0.15)
        : Colors.white.withOpacity(0.35);
  }

  static List<BoxShadow> glassShadow(bool isDark) {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(isDark ? 0.35 : 0.15),
        blurRadius: 30,
        offset: const Offset(0, 10),
      ),
    ];
  }
}

class GlassNoisePainter extends CustomPainter {
  const GlassNoisePainter({this.opacity = 0.03});

  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final random = Random();
    for (int i = 0; i < 250; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
          1,
          1,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
