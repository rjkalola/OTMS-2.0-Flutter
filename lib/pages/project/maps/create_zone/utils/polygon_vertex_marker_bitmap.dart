import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Small filled circle with a light border for polygon vertex [Marker]s.
class PolygonVertexMarkerBitmap {
  PolygonVertexMarkerBitmap._();

  static Future<BitmapDescriptor> build({
    required Color fill,
    Color borderColor = const Color(0xFFFFFFFF),
    double diameterPx = 20,
    double borderWidth = 2,
  }) async {
    final size = diameterPx.ceil().clamp(6, 44);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final center = Offset(size / 2, size / 2);
    final outerR = (size / 2) - 0.5;
    final innerR = (outerR - borderWidth).clamp(1.0, outerR);

    final borderPaint = Paint()
      ..color = borderColor
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    final fillPaint = Paint()
      ..color = fill
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, outerR, borderPaint);
    canvas.drawCircle(center, innerR, fillPaint);

    final picture = recorder.endRecording();
    final image = await picture.toImage(size, size);
    final bd = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = bd!.buffer.asUint8List();
    return BitmapDescriptor.bytes(bytes);
  }
}
