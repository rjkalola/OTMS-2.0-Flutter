import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Canvas-built zone label marker (bubble + stem + dot).
/// Renders at [rasterScale] for sharpness, then scales to [logicalMarkerHeight]
/// on the map via [BitmapDescriptor.bytes] (same idea as team user markers).
class ZoneLabelMarkerBitmap {
  ZoneLabelMarkerBitmap._();

  /// Anchor Y for [Marker] so the map point sits on the bottom dot (44× ref).
  static const double anchorY = 35 / 44;

  /// Raster density for PNG; scale with [logicalMarkerHeight] so text stays sharp.
  static const double rasterScale = 9.0;

  /// On-map height in logical pixels (2× the previous 60 — matches “double size”).
  static const double logicalMarkerHeight = 120.0;

  static Future<BitmapDescriptor> build({
    required String label,
    required Color zoneColor,
  }) async {
    final m = rasterScale;

    const double padX = 4;
    const double maxLabelWidth = 68;
    const double stemWidth = 0.7;
    const double bubbleH = 13;
    const double bubbleTop = 1;
    const double stemBottomY = 34;
    const double dotRadius = 1.4;

    final text = label.trim().isEmpty ? 'Zone' : label;
    final labelText = text.length > 15 ? '${text.substring(0, 15)}..' : text;

    final textPainter = TextPainter(
      text: TextSpan(
        text: labelText,
        style: TextStyle(
          color: const Color(0xFF111111),
          fontSize: 5 * m,
          fontWeight: FontWeight.w500,
          height: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '..',
    )..layout(maxWidth: maxLabelWidth * m);

    final bubbleW = textPainter.width + (padX * m * 2);
    final width = bubbleW + (6 * m);
    final height = 44.0 * m;

    final centerX = width / 2;
    final bubbleLeft = (width - bubbleW) / 2;

    final bubbleRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        bubbleLeft,
        bubbleTop * m,
        bubbleW,
        bubbleH * m,
      ),
      const Radius.circular(0),
    );

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final bubbleFill = Paint()
      ..color = Colors.white
      ..isAntiAlias = true;

    final bubbleBorder = Paint()
      ..color = zoneColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9 * m
      ..isAntiAlias = true;

    canvas.drawRRect(bubbleRect, bubbleFill);
    canvas.drawRRect(bubbleRect, bubbleBorder);

    final textDx = ((width - textPainter.width) / 2).roundToDouble();
    final textDy = ((bubbleTop * m) + ((bubbleH * m - textPainter.height) / 2))
        .roundToDouble();
    textPainter.paint(canvas, Offset(textDx, textDy));

    final stemPaint = Paint()
      ..color = zoneColor
      ..strokeWidth = stemWidth * m
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawLine(
      Offset(centerX, (bubbleTop + bubbleH) * m),
      Offset(centerX, stemBottomY * m),
      stemPaint,
    );

    final dotCenter = Offset(centerX, (stemBottomY + dotRadius) * m);

    final dotPaint = Paint()
      ..color = zoneColor
      ..isAntiAlias = true;

    canvas.drawCircle(dotCenter, dotRadius * m, dotPaint);

    final picture = recorder.endRecording();

    final wPx = width.ceil();
    final hPx = height.ceil();

    final image = await picture.toImage(wPx, hPx);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    final logicalW = logicalMarkerHeight * (wPx / hPx);

    return BitmapDescriptor.bytes(
      byteData!.buffer.asUint8List(),
      width: logicalW,
      height: logicalMarkerHeight,
    );
  }
}
