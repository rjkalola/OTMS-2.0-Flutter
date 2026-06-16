import 'dart:io';
import 'dart:ui' as ui;

import 'package:belcka/pages/manage_forms/form_details/model/form_signature_value.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/shared/form_signature_pad.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FormSignatureExporter {
  static Future<String?> exportToTempPng(FormSignatureValue value) async {
    if (value.isEmpty) return null;

    final width = value.canvasSize.width > 0 ? value.canvasSize.width : 400.0;
    final height = value.canvasSize.height > 0 ? value.canvasSize.height : 180.0;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      Paint()..color = FormSignaturePad.canvasColor,
    );

    final paint = Paint()
      ..color = FormSignaturePad.inkColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final stroke in value.strokes) {
      if (stroke.length < 2) continue;

      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (var index = 1; index < stroke.length; index++) {
        final point = stroke[index];
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, paint);
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(width.ceil(), height.ceil());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    final directory = await getTemporaryDirectory();
    final filePath = p.join(
      directory.path,
      'form_signature_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await File(filePath).writeAsBytes(byteData.buffer.asUint8List());
    return filePath;
  }
}
