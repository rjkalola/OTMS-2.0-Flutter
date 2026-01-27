import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final int activeIndex;

  DashedLinePainter(this.activeIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final dashWidth = 6.0;
    final dashSpace = 4.0;

    final y = size.height / 2;

    final firstX = 0.0;
    final secondX = size.width / 2;
    final thirdX = size.width;

    _drawDashed(
      canvas,
      firstX,
      secondX,
      y,
      activeIndex >= 1 ? Colors.blueAccent : Colors.grey.shade400,
      dashWidth,
      dashSpace,
      paint,
    );

    _drawDashed(
      canvas,
      secondX,
      thirdX,
      y,
      activeIndex >= 2 ? Colors.blueAccent : Colors.grey.shade400,
      dashWidth,
      dashSpace,
      paint,
    );
  }

  void _drawDashed(
      Canvas canvas,
      double startX,
      double endX,
      double y,
      Color color,
      double dashWidth,
      double dashSpace,
      Paint paint,
      ) {
    paint.color = color;
    double x = startX;
    while (x < endX) {
      canvas.drawLine(
        Offset(x, y),
        Offset(x + dashWidth, y),
        paint,
      );
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}