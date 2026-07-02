import 'package:belcka/pages/check_in/user_check_in/view/widgets/user_check_in_photos_before_section.dart';
import 'package:belcka/pages/check_in/user_check_out/controller/user_check_out_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCheckOutPhotosAfterSection extends StatelessWidget {
  UserCheckOutPhotosAfterSection({super.key});

  final controller = Get.put(UserCheckOutController());

  @override
  Widget build(BuildContext context) {
    final isEditable = StringHelper.isEmptyString(
        controller.checkLogInfo.value.checkoutDateTime);

    return Obx(() {
      final hasPhotos = controller.listAfterPhotos.isNotEmpty;
      final borderColor = hasPhotos
          ? UserCheckInPhotosBeforeColors.added
          : UserCheckInPhotosBeforeColors.accent;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: UserCheckInPhotosBeforeColors.cardShadow(context),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        UserCheckInPhotosBeforeColors.iconBackground(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: ImageUtils.setSvgAssetsImage(
                      path: Drawable.checkinPhotosBeforeAfterCameraIcon,
                      width: 22,
                      height: 22,
                      color: UserCheckInPhotosBeforeColors.accent,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'photos_after'.tr,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: primaryTextColor_(context),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'take_photo_after_completing_job'.tr,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: secondaryTextColor_(context),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: isEditable ? controller.onSelectCommonAfterPhotos : null,
              behavior: HitTestBehavior.opaque,
              child: _DashedBorder(
                color: borderColor,
                radius: 14,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  color: hasPhotos
                      ? UserCheckInPhotosBeforeColors.addedFill(context)
                      : UserCheckInPhotosBeforeColors.takePhotoFill(context),
                  child: hasPhotos
                      ? const _AddedContent()
                      : const _TakePhotoContent(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _TakePhotoContent extends StatelessWidget {
  const _TakePhotoContent();

  @override
  Widget build(BuildContext context) {
    const color = UserCheckInPhotosBeforeColors.accent;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: UserCheckInPhotosBeforeColors.takePhotoCircleFill(context),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: ImageUtils.setSvgAssetsImage(
              path: Drawable.checkinAddPhotosBeforeAfterCameraIcon,
              width: 36,
              height: 36,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'take_photo'.tr,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _AddedContent extends StatelessWidget {
  const _AddedContent();

  @override
  Widget build(BuildContext context) {
    const color = UserCheckInPhotosBeforeColors.added;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle_rounded, color: color, size: 22),
        const SizedBox(width: 8),
        Text(
          'added'.tr,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _DashedBorder extends StatelessWidget {
  const _DashedBorder({
    required this.child,
    required this.color,
    this.radius = 14,
    this.strokeWidth = 1.4,
    this.dashWidth = 5,
    this.dashSpace = 4,
  });

  final Widget child;
  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
