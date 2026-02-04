import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final double height;
  final List<Color>? gradientColors;

  const AnimatedProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.height = 8,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, val, _) {
          return LinearProgressIndicator(
            value: val,
            minHeight: height,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
                gradientColors == null ? color : gradientColors!.first),
          );
        },
      ),
    );
  }
}