import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Draws the full check-log connector tree in one continuous path.
class CheckLogTreeConnectorPainter extends CustomPainter {
  final List<double> branchCentersY;
  final Color color;

  CheckLogTreeConnectorPainter({
    required this.branchCentersY,
    required this.color,
  });

  /// Half-pixel aligned for crisp 1px strokes without antialias gaps.
  static const double lineX = 0.5;
  static const double cornerRadius = 10;
  static const double jointOverlap = 0.75;
  /// Extends slightly into the card edge so the branch meets the border.
  static const double cardEdgeOverlap = 1;

  double _radiusFor(double centerY, double branchEndX) {
    return math.min(
      cornerRadius,
      math.min(branchEndX - lineX - 1, centerY - 1),
    ).clamp(0.0, cornerRadius);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (branchCentersY.isEmpty) return;

    final branchEndX = size.width;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final lastCenterY = branchCentersY.last;
    final lastRadius = _radiusFor(lastCenterY, branchEndX);

    // Continuous vertical spine.
    canvas.drawLine(
      const Offset(lineX, -jointOverlap),
      Offset(lineX, lastCenterY - lastRadius),
      paint,
    );

    final branchPath = Path();
    for (final centerY in branchCentersY) {
      final radius = _radiusFor(centerY, branchEndX);
      final elbowY = centerY - radius;

      branchPath
        ..moveTo(lineX, elbowY - jointOverlap)
        ..lineTo(lineX, elbowY);

      if (radius > 0) {
        branchPath.arcToPoint(
          Offset(lineX + radius, centerY),
          radius: Radius.circular(radius),
          clockwise: false,
        );
      } else {
        branchPath.lineTo(lineX, centerY);
      }

      branchPath.lineTo(branchEndX, centerY);
    }

    canvas.drawPath(branchPath, paint);
  }

  @override
  bool shouldRepaint(CheckLogTreeConnectorPainter oldDelegate) {
    if (oldDelegate.color != color) return true;
    if (oldDelegate.branchCentersY.length != branchCentersY.length) {
      return true;
    }
    for (var i = 0; i < branchCentersY.length; i++) {
      if ((oldDelegate.branchCentersY[i] - branchCentersY[i]).abs() > 0.5) {
        return true;
      }
    }
    return false;
  }
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
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawLine(
      const Offset(CheckLogTreeConnectorPainter.lineX, 0),
      Offset(
        CheckLogTreeConnectorPainter.lineX,
        size.height + CheckLogTreeConnectorPainter.jointOverlap,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CheckLogTopConnectorPainter oldDelegate) =>
      oldDelegate.color != color;
}
