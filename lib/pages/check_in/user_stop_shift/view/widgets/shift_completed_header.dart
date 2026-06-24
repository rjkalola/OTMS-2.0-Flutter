import 'package:belcka/pages/check_in/user_stop_shift/controller/user_stop_shift_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShiftCompletedHeader extends StatelessWidget {
  ShiftCompletedHeader({super.key});

  final controller = Get.put(UserStopShiftController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isCompleted = !controller.isWorking.value;

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            if (isCompleted) ...[
              _SuccessIcon(),
              SizedBox(height: 10,),
              Text(
                'shift_completed'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: primaryTextColor_(context),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'great_job_today'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: secondaryTextColor_(context),
                ),
              ),
            ] else ...[
              const SizedBox(height: 8),
              Text(
                'my_shift'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: primaryTextColor_(context),
                ),
              ),
            ],
            const SizedBox(height: 16),
            _DatePill(date: controller.formattedWorkDate),
          ],
        ),
      );
    });
  }
}

class _SuccessIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Drawable.stopShiftDoneImage,
      width: 160,
      height: 90,
      fit: BoxFit.contain,
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill({required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    if (date.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dividerColor_(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageUtils.setSvgAssetsImage(
            path: Drawable.timesheetClockInScreenIcon,
            width: 20,
            height: 20,
            color: secondaryTextColor_(context)
          ),
          const SizedBox(width: 8),
          Text(
            date,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: secondaryTextColor_(context),
            ),
          ),
        ],
      ),
    );
  }
}
