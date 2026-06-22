import 'package:flutter/material.dart';

class ClipboardIllustration extends StatelessWidget {
  const ClipboardIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, height: 120,
      decoration: const BoxDecoration(
        color: Color(0xFFEEEFF5),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(72, 80),
          painter: _ClipboardPainter(),
        ),
      ),
    );
  }
}

class _ClipboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(4, 14, w - 2, h - 10), const Radius.circular(8)),
      Paint()..color = Colors.black.withOpacity(0.08)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 10, w, h - 8), const Radius.circular(8)),
      Paint()..color = Colors.white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 10, w, h - 8), const Radius.circular(8)),
      Paint()..color = const Color(0xFFF0C040)..style = PaintingStyle.stroke..strokeWidth = 2.5,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.28, 0, w * 0.44, 18), const Radius.circular(5)),
      Paint()..color = const Color(0xFFE05555),
    );
    canvas.drawCircle(Offset(w / 2, 8), 4, Paint()..color = const Color(0xFF333333));

    final lp = Paint()..color = const Color(0xFFCCCEDC)..strokeWidth = 3..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.18, h * 0.42), Offset(w * 0.82, h * 0.42), lp);
    canvas.drawLine(Offset(w * 0.18, h * 0.57), Offset(w * 0.82, h * 0.57), lp);
    canvas.drawLine(Offset(w * 0.18, h * 0.72), Offset(w * 0.59, h * 0.72), lp);
  }

  @override
  bool shouldRepaint(_ClipboardPainter old) => false;
}