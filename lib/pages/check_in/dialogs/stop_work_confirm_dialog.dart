import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StopWorkConfirmDialog extends StatelessWidget {
  final String workedTime;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const StopWorkConfirmDialog({
    super.key,
    required this.workedTime,
    required this.onConfirm,
    required this.onCancel,
  });

  static const Color _yesColor = Color(0xFF32A852);
  static const Color _noColor = Color(0xFFFF484B);

  List<BoxShadow> _glowShadow(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.62),
          blurRadius: 10,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor_(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _DialogClockIcon(),
            const SizedBox(height: 16),
            Text(
              'stop_work_question'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: primaryTextColor_(context),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'stop_work_job_confirm'.tr,
              textAlign: TextAlign.center, 
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: secondaryTextColor_(context),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: titleBgColor_(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ImageUtils.setSvgAssetsImage(
                    path: Drawable.workTimeCalendarIcon,
                    width: 28,
                    height: 28,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'todays_worked_time'.tr,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: secondaryTextColor_(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        workedTime,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: primaryTextColor_(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(child: _buildNoButton(context)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildYesButton()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoButton(BuildContext context) {
    return GestureDetector(
      onTap: onCancel,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _noColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: _noColor.withOpacity(0.38),
              blurRadius: 7,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          'no'.tr,
          style: const TextStyle(
            color: _noColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildYesButton() {
    return GestureDetector(
      onTap: onConfirm,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: _yesColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: _glowShadow(_yesColor),
        ),
        alignment: Alignment.center,
        child: Text(
          'yes'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _DialogClockIcon extends StatelessWidget {
  const _DialogClockIcon();

  static const Color _circleBg = Color(0xFFE8EEFF);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      height: 92,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: _circleBg,
              shape: BoxShape.circle,
            ),
          ),
          Image.asset(
            Drawable.stopWorkDialogClockIcon,
            width: 66,
            height: 66,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ],
      ),
    );
  }
}
