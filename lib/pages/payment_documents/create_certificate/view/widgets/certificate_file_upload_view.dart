import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CertificateFileUploadView extends StatelessWidget {
  const CertificateFileUploadView({
    super.key,
    required this.filePath,
    required this.selectedFileName,
    required this.onUploadTap,
    required this.onRemove,
  });

  final RxString filePath;
  final RxString selectedFileName;
  final VoidCallback onUploadTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final hasFile = !StringHelper.isEmptyString(filePath.value);
        return GestureDetector(
          onTap: onUploadTap,
          child: CustomPaint(
            painter: _DashedBorderPainter(
              color: defaultAccentColor_(context),
              radius: 16,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              decoration: BoxDecoration(
                color: backgroundColor_(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: hasFile
                  ? _SelectedFileView(
                      fileName: selectedFileName.value,
                      onRemove: onRemove,
                    )
                  : _EmptyUploadView(),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyUploadView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.cloud_upload_outlined,
          size: 36,
          color: defaultAccentColor_(context),
        ),
        const SizedBox(height: 12),
        PrimaryTextView(
          text: 'tap_to_upload'.tr,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: defaultAccentColor_(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        PrimaryTextView(
          text: 'certificate_upload_hint'.tr,
          fontSize: 13,
          color: secondaryExtraLightTextColor_(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SelectedFileView extends StatelessWidget {
  const _SelectedFileView({
    required this.fileName,
    required this.onRemove,
  });

  final String fileName;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.insert_drive_file_outlined,
          color: defaultAccentColor_(context),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: PrimaryTextView(
            text: fileName,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            maxLine: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          onPressed: onRemove,
          icon: Icon(
            Icons.close,
            size: 20,
            color: secondaryLightTextColor_(context),
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.radius,
  });

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
