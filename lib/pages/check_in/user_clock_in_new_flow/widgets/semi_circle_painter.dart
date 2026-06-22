import 'dart:math' as math;

import 'package:flutter/material.dart';

class SemiCirclePainter extends CustomPainter {
  final double progress;

  SemiCirclePainter({this.progress = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final outerRadius = size.width / 2 - 10;
    final innerRadius = size.width / 2 - 44;

    // Outer faint track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      math.pi, math.pi, false,
      Paint()
        ..color = Colors.white.withOpacity(0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );

    // Inner faint track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      math.pi, math.pi, false,
      Paint()
        ..color = Colors.white.withOpacity(0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round,
    );

    // Progress arc
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        math.pi, math.pi * progress, false,
        Paint()
          ..color = Colors.white.withOpacity(0.9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    }

    // Dot indicator
    final dotAngle = math.pi + math.pi * progress;
    final dotX = center.dx + outerRadius * math.cos(dotAngle);
    final dotY = center.dy + outerRadius * math.sin(dotAngle);

    canvas.drawCircle(
      Offset(dotX, dotY), 9,
      Paint()..color = Colors.white.withOpacity(0.3),
    );
    canvas.drawCircle(
      Offset(dotX, dotY), 5,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(SemiCirclePainter old) => old.progress != progress;
}