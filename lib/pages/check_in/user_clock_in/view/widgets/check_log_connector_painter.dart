import 'package:flutter/material.dart';

class CheckLogConnectorPainter extends CustomPainter {
  final Color color;
  final bool isLast;

  CheckLogConnectorPainter({
    required this.color,
    required this.isLast,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.height <= 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter
      ..isAntiAlias = false;

    const x = 0.5;
    final centerY = size.height / 2;
    final path = Path()
      ..moveTo(x, 0)
      ..lineTo(x, centerY)
      ..lineTo(size.width, centerY);

    canvas.drawPath(path, paint);

    if (!isLast) {
      canvas.drawLine(
        Offset(x, centerY),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CheckLogConnectorPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isLast != isLast;
}

class CheckLogTopConnectorPainter extends CustomPainter {
  final Color color;

  CheckLogTopConnectorPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..isAntiAlias = false;

    canvas.drawLine(
      const Offset(0.5, 0),
      Offset(0.5, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CheckLogTopConnectorPainter oldDelegate) =>
      oldDelegate.color != color;
}
