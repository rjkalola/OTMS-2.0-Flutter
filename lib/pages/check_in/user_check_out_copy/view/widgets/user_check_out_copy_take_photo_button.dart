import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCheckOutCopyTakePhotoButton extends StatelessWidget {
  const UserCheckOutCopyTakePhotoButton({
    super.key,
    required this.hasPhoto,
    required this.onTap,
    this.fullWidth = false,
  });

  final bool hasPhoto;
  final VoidCallback onTap;
  final bool fullWidth;

  static const Color _takePhotoColor = Color(0xFF0D6EFD);
  static const Color _addedColor = Color(0xFF32A852);

  @override
  Widget build(BuildContext context) {
    final photoBorderColor = hasPhoto ? _addedColor : _takePhotoColor;

    final content = _DashedBorder(
      color: photoBorderColor,
      radius: 5,
      fullWidth: fullWidth,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: fullWidth ? 14 : 10,
          vertical: fullWidth ? 12 : 8,
        ),
        color: hasPhoto
            ? _addedColor.withOpacity(0.06)
            : _takePhotoColor.withOpacity(0.04),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment:
              fullWidth ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            ImageUtils.setSvgAssetsImage(
              path: Drawable.checkinCameraIcon,
              width: 16,
              height: 16,
              color: photoBorderColor,
            ),
            const SizedBox(width: 6),
            Text(
              hasPhoto ? 'added'.tr : 'take_photo'.tr,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: photoBorderColor,
              ),
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: fullWidth
          ? SizedBox(width: double.infinity, child: content)
          : content,
    );
  }
}

class _DashedBorder extends StatelessWidget {
  const _DashedBorder({
    required this.child,
    required this.color,
    this.radius = 10,
    this.fullWidth = false,
    this.strokeWidth = 1.2,
    this.dashWidth = 4,
    this.dashSpace = 3,
  });

  final Widget child;
  final Color color;
  final double radius;
  final bool fullWidth;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  @override
  Widget build(BuildContext context) {
    final border = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CustomPaint(
        foregroundPainter: _DashedRRectPainter(
          color: color,
          radius: radius,
          strokeWidth: strokeWidth,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
        ),
        child: child,
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: border);
    }
    return border;
  }
}

class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final half = strokeWidth / 2;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          half, half, size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
