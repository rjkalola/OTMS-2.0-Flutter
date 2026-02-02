import 'package:flutter/material.dart';

class StaticOverallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 18.0;
    final radius = size.width / 2;
    final center = Offset(radius, radius);

    final segments = [
      _Segment(color: Color(0xFF0956CA), sweep: 1.80), // Blue
      _Segment(color: Color(0xFF65BB64), sweep: 1.25), // Green
      _Segment(color: Color(0xFFF26B4D), sweep: 0.85), // Red
      _Segment(color: Color(0xFF576F8F), sweep: 1.90), // Grey
    ];

    const gapAngle = 0.12;
    double startAngle = -3.1415926535 / 2;

    for (final segment in segments) {
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius - strokeWidth / 2,
        ),
        startAngle,
        segment.sweep,
        false,
        paint,
      );
      startAngle += segment.sweep + gapAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _Segment {
  final Color color;
  final double sweep;

  const _Segment({
    required this.color,
    required this.sweep,
  });
}