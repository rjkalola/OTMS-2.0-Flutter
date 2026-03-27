import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserMapPinWidget extends StatelessWidget {
  const UserMapPinWidget({
    super.key,
    required this.userName,
    required this.isWorking,
    this.basePinImage,
    this.avatarImage,
    this.width = 24,
    this.height = 30,
  });

  final String userName;
  final bool isWorking;
  final ui.Image? basePinImage;
  final ui.Image? avatarImage;
  final double width;
  final double height;

  static const double renderScale = 2.5;

  static Future<BitmapDescriptor> toBitmapDescriptor({
    required String userName,
    required bool isWorking,
    ui.Image? basePinImage,
    ui.Image? avatarImage,
    double width = 24,
    double height = 30,
    double scale = renderScale,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.scale(scale, scale);

    final painter = _UserMapPinPainter(
      userName: userName,
      isWorking: isWorking,
      basePinImage: basePinImage,
      avatarImage: avatarImage,
      width: width,
      height: height,
    );
    painter.paint(canvas, Size(width, height));

    final picture = recorder.endRecording();
    final image =
        await picture.toImage((width * scale).ceil(), (height * scale).ceil());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = data?.buffer.asUint8List() ?? Uint8List(0);
    return BitmapDescriptor.bytes(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _UserMapPinPainter(
          userName: userName,
          isWorking: isWorking,
          basePinImage: basePinImage,
          avatarImage: avatarImage,
          width: width,
          height: height,
        ),
      ),
    );
  }
}

class _UserMapPinPainter extends CustomPainter {
  _UserMapPinPainter({
    required this.userName,
    required this.isWorking,
    required this.basePinImage,
    required this.avatarImage,
    required this.width,
    required this.height,
  });

  final String userName;
  final bool isWorking;
  final ui.Image? basePinImage;
  final ui.Image? avatarImage;
  final double width;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    final pinCenterX = width * 0.5;
    final pinCenterY = height * 0.375;
    final avatarRadius = width * 0.235;
    final pinCenter = Offset(pinCenterX, pinCenterY);

    if (basePinImage != null) {
      final src = Rect.fromLTWH(
        0,
        0,
        basePinImage!.width.toDouble(),
        basePinImage!.height.toDouble(),
      );
      final dst = Rect.fromLTWH(0, 0, width, height);
      canvas.drawImageRect(basePinImage!, src, dst, Paint());
    } else {
      final pinPaint = Paint()..color = const Color(0xFF1E88FF);
      canvas.drawCircle(pinCenter, 7.2, pinPaint);
      final path = Path()
        ..moveTo(pinCenterX - 3.2, pinCenterY + 4.8)
        ..lineTo(pinCenterX + 3.2, pinCenterY + 4.8)
        ..lineTo(pinCenterX, height - 2)
        ..close();
      canvas.drawPath(path, pinPaint);
    }

    final avatarCenter = Offset(pinCenterX, pinCenterY);
    final avatarRect =
        Rect.fromCircle(center: avatarCenter, radius: avatarRadius);

    canvas.save();
    canvas.clipPath(Path()..addOval(avatarRect));
    if (avatarImage != null) {
      paintImage(
        canvas: canvas,
        rect: avatarRect,
        image: avatarImage!,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.none,
      );
    } else {
      final fallback = Paint()..color = const Color(0xFFE3F2FD);
      canvas.drawCircle(avatarCenter, avatarRadius, fallback);
      final letter =
          (userName.trim().isNotEmpty ? userName.trim()[0] : 'U').toUpperCase();
      final tp = TextPainter(
        text: TextSpan(
          text: letter,
          style: const TextStyle(
            color: Color(0xFF1565C0),
            fontSize: 7.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(pinCenterX - tp.width / 2, pinCenterY - tp.height / 2),
      );
    }
    canvas.restore();

    final avatarRing = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;
    canvas.drawCircle(avatarCenter, avatarRadius, avatarRing);

    final statusCenter = Offset(pinCenterX + 5.0, pinCenterY + 4.6);
    final statusOuter = Paint()..color = Colors.white;
    final statusInner = Paint()
      ..color = isWorking ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    canvas.drawCircle(statusCenter, 1.8, statusOuter);
    canvas.drawCircle(statusCenter, 1.2, statusInner);
  }

  @override
  bool shouldRepaint(covariant _UserMapPinPainter oldDelegate) {
    return oldDelegate.userName != userName ||
        oldDelegate.isWorking != isWorking ||
        oldDelegate.basePinImage != basePinImage ||
        oldDelegate.avatarImage != avatarImage ||
        oldDelegate.width != width ||
        oldDelegate.height != height;
  }
}
