import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:belcka/res/drawable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

/// Composites [Drawable.customMapMarker] with a circular user thumbnail in the
/// asset’s transparent cutout. No widget-to-bitmap pipeline.
class TeamUserMarkerBitmap {
  TeamUserMarkerBitmap._();

  static ui.Image? _pinFrame;

  static Future<ui.Image> _loadPinFrame() async {
    if (_pinFrame != null) return _pinFrame!;
    final data = await rootBundle.load(Drawable.customMapMarker);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    _pinFrame = frame.image; 
    return _pinFrame!;
  }

  /// Hole geometry tuned for [ic_custom_map_marker.png] (512×512).
  static const double _holeCxNorm = 0.517;
  /// Radius of thumb hole in 512×512 asset pixels (matches [118 * 1.2] scale).
  static const double _refHoleRadiusPx = 118 * 1.2;
  /// Vertical center: prior baseline + 10% of hole diameter toward bottom.
  static const double _holeCyNorm =
      (168 + 0.1 * 2 * _refHoleRadiusPx) / 512;
  static const double _holeRadiusNorm = _refHoleRadiusPx / 512;

  /// Raster size used when painting the PNG (higher = sharper thumbs).
  static const double _renderPixelSize = 144;

  /// On-map footprint in logical pixels (~12.5% larger than 40; within 10–15% bump).
  static const double _displayLogicalSize = 45;

  static Future<BitmapDescriptor> build({String? thumbUrl}) async {
    final pin = await _loadPinFrame();
    ui.Image? thumb;
    final thumbUrlNonNull = thumbUrl;
    if (thumbUrlNonNull != null && thumbUrlNonNull.trim().isNotEmpty) {
      final url = thumbUrlNonNull.trim();
      try {
        final uri = Uri.tryParse(url);
        if (uri != null && uri.hasScheme) {
          final res = await http.get(uri).timeout(const Duration(seconds: 15));
          if (res.statusCode == 200 && res.bodyBytes.isNotEmpty) {
            final codec = await ui.instantiateImageCodec(res.bodyBytes);
            final frame = await codec.getNextFrame();
            thumb = frame.image;
          }
        }
      } catch (_) {
        thumb = null;
      }
    }

    final w = _renderPixelSize;
    final h = _renderPixelSize;
    final cx = w * _holeCxNorm;
    final cy = h * _holeCyNorm;
    final holeR = w * _holeRadiusNorm;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder); 

    final holeRect = Rect.fromCircle(center: Offset(cx, cy), radius: holeR);
    canvas.save();
    canvas.clipPath(Path()..addOval(holeRect));
    if (thumb != null) {
      _drawImageCover(canvas, thumb, holeRect);
    } else {
      canvas.drawRect(
        holeRect,
        Paint()..color = const Color(0xFFE0E0E0),
      );
    }
    canvas.restore();

    canvas.drawImageRect(
      pin,
      Rect.fromLTWH(0, 0, pin.width.toDouble(), pin.height.toDouble()),
      Rect.fromLTWH(0, 0, w, h),
      Paint()..isAntiAlias = true,
    );

    if (thumb != null) {
      thumb.dispose();
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(w.ceil(), h.ceil());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    return BitmapDescriptor.bytes(
      byteData!.buffer.asUint8List(),
      width: _displayLogicalSize,
      height: _displayLogicalSize,
    );
  }

  static void _drawImageCover(Canvas canvas, ui.Image image, Rect dst) {
    final iw = image.width.toDouble();
    final ih = image.height.toDouble();
    if (iw <= 0 || ih <= 0) return;
    final sx = dst.width / iw;
    final sy = dst.height / ih;
    final scale = math.max(sx, sy);
    final sw = iw * scale;
    final sh = ih * scale;
    final left = dst.left + (dst.width - sw) / 2;
    final top = dst.top + (dst.height - sh) / 2;
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, iw, ih),
      Rect.fromLTWH(left, top, sw, sh),
      Paint()..isAntiAlias = true,
    );
  }
}
