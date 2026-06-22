// --- CUSTOM PAINTER FOR CONNECTING TREE LINES ---
import 'package:flutter/material.dart';

class TreeLinePainter extends CustomPainter {
  final int jobCount;
  TreeLinePainter({required this.jobCount});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD2D7E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Hardcoded node spacing to match layouts perfectly
    // Project Card baseline starts around X=24.
    const double startX = 24;
    const double startY = 55; // Vertical midpoint of the main Project Card
    const double endX = 42;   // Where the line meets the job card boundary

    // First branch dimensions
    const double firstJobCenterY = 145;
    const double jobSpacing = 94; // Vertical step distance between job rows

    for (int i = 0; i < jobCount; i++) {
      final double targetY = firstJobCenterY + (i * jobSpacing);
      final path = Path();

      // Start from underneath the project card's accent bar
      path.moveTo(startX, startY);

      // Draw straight down, then construct a clean cubic bezier curve into the job item
      path.lineTo(startX, targetY - 16);
      path.cubicTo(
        startX, targetY,       // Control point 1
        startX + 4, targetY,   // Control point 2
        endX, targetY,         // Ending point
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant TreeLinePainter oldDelegate) =>
      oldDelegate.jobCount != jobCount;
}