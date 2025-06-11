import 'dart:math';

import 'package:flutter/material.dart';
class CustomCupertinoSpinner extends StatefulWidget {
  final double radius;
  final Color color;
  final bool animating;

  const CustomCupertinoSpinner({
    this.radius = 10,
    this.color = Colors.grey,
    this.animating = true,
  });

  @override
  State<CustomCupertinoSpinner> createState() =>
      _CustomCupertinoSpinnerState();
}

class _CustomCupertinoSpinnerState extends State<CustomCupertinoSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const int tickCount = 12;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    if (widget.animating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant CustomCupertinoSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating != oldWidget.animating) {
      widget.animating ? _controller.repeat() : _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.radius * 2;

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            painter: _CupertinoSpinnerPainter(
              ticks: tickCount,
              animationValue: _controller.value,
              color: widget.color,
              radius: widget.radius,
            ),
          );
        },
      ),
    );
  }
}

class _CupertinoSpinnerPainter extends CustomPainter {
  final int ticks;
  final double animationValue;
  final Color color;
  final double radius;

  _CupertinoSpinnerPainter({
    required this.ticks,
    required this.animationValue,
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final tickWidth = radius * 0.1;
    final tickHeight = radius * 0.6;
    final angleStep = 2 * 3.1415926 / ticks;

    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = tickWidth;

    for (int i = 0; i < ticks; i++) {
      final t = (i + animationValue * ticks) % ticks;
      final opacity = (1.0 - t / ticks).clamp(0.0, 1.0);

      paint.color = color.withOpacity(opacity);

      final angle = i * angleStep;
      final start = Offset(
        center.dx + radius * 0.3 * cos(angle),
        center.dy + radius * 0.3 * sin(angle),
      );
      final end = Offset(
        center.dx + radius * 0.8 * cos(angle),
        center.dy + radius * 0.8 * sin(angle),
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
