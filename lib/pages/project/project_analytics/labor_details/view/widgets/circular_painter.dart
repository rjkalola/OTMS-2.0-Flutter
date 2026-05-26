import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final double progress;
  CirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = cx - 4;
    const pi2 = 3.14159265 * 2;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, -pi2 / 4, pi2, false, trackPaint);
    canvas.drawArc(rect, -pi2 / 4, pi2 * progress, false, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}