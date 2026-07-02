import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';
import 'package:belcka/pages/check_in/user_check_in_copy/controller/user_check_in_copy_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCheckInCopyTaskSection extends StatelessWidget {
  UserCheckInCopyTaskSection({super.key});

  final controller = Get.put(UserCheckInCopyController());

  static const Color _taskIconBg = Color(0xFFF3E8FC);
  static const Color _taskRowIconBg = Color(0xFFFFF3E8);
  static const Color _takePhotoColor = Color(0xFF0D6EFD);
  static const Color _addedColor = Color(0xFF32A852);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final taskText = controller.typeOfWorkController.value.text;
      final hasTask = controller.selectedTypeOfWorkList.isNotEmpty;
      final tasks = controller.selectedTypeOfWorkList;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: controller.showSelectTypeOfWorkDialog,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _taskIconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: ImageUtils.setSvgAssetsImage(
                          path: Drawable.checkinTaskIcon,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'select_task'.tr,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: primaryTextColor_(context),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            hasTask ? taskText : 'choose_todays_task'.tr,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: hasTask
                                  ? primaryTextColor_(context)
                                  : secondaryTextColor_(context),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: secondaryTextColor_(context),
                    ),
                  ],
                ),
              ),
            ),
            if (hasTask) ...[
              // Divider(
              //   height: 1,
              //   thickness: 1,
              //   color: dividerColor_(context),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
                child: Text(
                  'your_tasks'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: secondaryTextColor_(context),
                  ),
                ),
              ),
              ...List.generate(tasks.length, (index) {
                final info = tasks[index];
                return Padding(
                  padding: EdgeInsets.fromLTRB(14, 0, 14, index == tasks.length - 1 ? 12 : 8),
                  child: _TaskRow(
                    info: info,
                    onPhotoTap: () =>
                        controller.onSelectTypeOfWorkPhotos(index),
                    onDetailsTap: () => controller.typeOfWorkDetails(info),
                  ),
                );
              }),
            ],
          ],
        ),
      );
    });
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.info,
    required this.onPhotoTap,
    required this.onDetailsTap,
  });

  final TypeOfWorkResourcesInfo info;
  final VoidCallback onPhotoTap;
  final VoidCallback onDetailsTap;

  static const Color _taskRowIconBg = Color(0xFFFFF3E8);
  static const Color _taskRowIconColor = Color(0xFFFF7F00);
  static const Color _takePhotoColor = Color(0xFF0D6EFD);
  static const Color _addedColor = Color(0xFF32A852);

  @override
  Widget build(BuildContext context) {
    final hasPhoto = !StringHelper.isEmptyList(info.beforeAttachments);
    final borderColor = hasPhoto ? _addedColor : _takePhotoColor;

    return GestureDetector(
      onTap: onDetailsTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: dividerColor_(context)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _taskRowIconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: ImageUtils.setSvgAssetsImage(
                  path: Drawable.checkinTaskIcon,
                  width: 18,
                  height: 18,
                  color: _taskRowIconColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                info.name ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: primaryTextColor_(context),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onPhotoTap,
              child: _DashedBorder(
                color: borderColor,
                radius: 5,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  color: hasPhoto
                      ? _addedColor.withOpacity(0.06)
                      : _takePhotoColor.withOpacity(0.04),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ImageUtils.setSvgAssetsImage(
                        path: Drawable.checkinCameraIcon,
                        width: 16,
                        height: 16,
                        color: borderColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        hasPhoto ? 'added'.tr : 'take_photo'.tr,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: borderColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorder extends StatelessWidget {
  const _DashedBorder({
    required this.child,
    required this.color,
    this.radius = 10,
    this.strokeWidth = 1.2,
    this.dashWidth = 4,
    this.dashSpace = 3,
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
      Rect.fromLTWH(half, half, size.width - strokeWidth, size.height - strokeWidth),
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
