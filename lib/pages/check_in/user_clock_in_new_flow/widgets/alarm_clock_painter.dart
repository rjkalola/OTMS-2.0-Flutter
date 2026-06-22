import 'package:flutter/material.dart';

class AlarmClockPainter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(56, 56),
      painter: AlarmClockCustomPainter(),
    );
  }
}

class AlarmClockCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 4;
    final r = size.width * 0.38;

    canvas.drawCircle(
      Offset(cx, cy + 3),
      r,
      Paint()
        ..color = Colors.red.withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()..color = const Color(0xFFE53935),
    );

    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.78,
      Paint()..color = Colors.white,
    );

    final handPaint = Paint()
      ..color = const Color(0xFF333333)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx - r * 0.28, cy - r * 0.35),
      handPaint,
    );
    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx, cy - r * 0.50),
      handPaint,
    );

    canvas.drawCircle(
      Offset(cx, cy),
      2.5,
      Paint()..color = const Color(0xFFE53935),
    );

    final bellPaint = Paint()..color = const Color(0xFFE53935);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx - r * 0.88, cy - r * 0.55),
          width: r * 0.38,
          height: r * 0.25,
        ),
        const Radius.circular(4),
      ),
      bellPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx + r * 0.88, cy - r * 0.55),
          width: r * 0.38,
          height: r * 0.25,
        ),
        const Radius.circular(4),
      ),
      bellPaint,
    );
    final legPaint = Paint()
      ..color = const Color(0xFFE53935)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx - r * 0.45, cy + r * 0.88),
      Offset(cx - r * 0.65, cy + r * 1.1),
      legPaint,
    );
    canvas.drawLine(
      Offset(cx + r * 0.45, cy + r * 0.88),
      Offset(cx + r * 0.65, cy + r * 1.1),
      legPaint,
    );

    final ringPaint = Paint()
      ..color = const Color(0xFFE53935)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx - r * 1.05, cy - r * 0.9),
      Offset(cx - r * 1.25, cy - r * 1.1),
      ringPaint,
    );
    canvas.drawLine(
      Offset(cx - r * 0.85, cy - r * 1.1),
      Offset(cx - r * 1.0, cy - r * 1.35),
      ringPaint,
    );
    canvas.drawLine(
      Offset(cx + r * 1.05, cy - r * 0.9),
      Offset(cx + r * 1.25, cy - r * 1.1),
      ringPaint,
    );
    canvas.drawLine(
      Offset(cx + r * 0.85, cy - r * 1.1),
      Offset(cx + r * 1.0, cy - r * 1.35),
      ringPaint,
    );
  }

  @override
  bool shouldRepaint(AlarmClockCustomPainter old) => false;
}