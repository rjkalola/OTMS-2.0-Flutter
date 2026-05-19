import 'dart:math' as math;

import 'package:belcka/pages/project/project_analytics/view/widgets/donut_section.dart';
import 'package:flutter/material.dart';

class DonutChart extends StatelessWidget {
  final List<DonutSection> sections;
  final String centerLabel;
  final String centerValue;
  const DonutChart(
      {required this.sections,
        required this.centerLabel,
        required this.centerValue});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DonutPainter(sections: sections),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(centerLabel,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500)),
            Text(
              centerValue,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2563EB)),
            ),
          ],
        ),
      ),
    );
  }
}

class DonutPainter extends CustomPainter {
  final List<DonutSection> sections;
  DonutPainter({required this.sections});

  @override
  void paint(Canvas canvas, Size size) {
    final total = sections.fold(0.0, (s, e) => s + e.value);
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = math.min(cx, cy) - 6;
    const strokeW = 14.0;
    const gap = 0.04;

    double startAngle = -math.pi / 2;

    for (final s in sections) {
      final sweep = (s.value / total) * (2 * math.pi) - gap;
      final paint = Paint()
        ..color = s.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        startAngle,
        sweep,
        false,
        paint,
      );
      startAngle += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}