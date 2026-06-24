import 'dart:math' as math;

import 'package:flutter/material.dart';

class UserClockInSemiCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius - 34;

    // Place arc apex around upper third of header (aligned with back button area).
    final apexY = size.height * 0.28;
    final center = Offset(centerX, apexY + outerRadius);

    final outerPaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final innerPaint = Paint()
      ..color = Colors.white.withOpacity(0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      math.pi,
      math.pi,
      false,
      outerPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      math.pi,
      math.pi,
      false,
      innerPaint,
    );

    final dotX = center.dx;
    final dotY = apexY;

    canvas.drawCircle(
      Offset(dotX, dotY),
      9,
      Paint()..color = Colors.white.withOpacity(0.3),
    );
    canvas.drawCircle(
      Offset(dotX, dotY),
      5,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
