import 'package:belcka/pages/check_in/user_stop_shift/controller/user_stop_shift_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShiftTimesCard extends StatelessWidget {
  ShiftTimesCard({super.key});

  final controller = Get.put(UserStopShiftController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.showRequestedShiftCard) {
        return const SizedBox.shrink();
      }

      final canEdit = controller.canEditTimes;

      return Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _TimeColumn(
                time: controller.actualStartTimeDisplay,
                label: 'started'.tr,
                showEdit: canEdit,
                onEditTap: () => controller.showTimePickerDialog(
                  AppConstants.dialogIdentifier.selectShiftStartTime,
                  DateUtil.getDateTimeFromHHMM(controller.startTime.value),
                ),
              ),
            ),
            Icon(Icons.arrow_forward_rounded,
                color: secondaryTextColor_(context), size: 22),
            Expanded(
              child: _TimeColumn(
                time: controller.actualEndTimeDisplay,
                label: 'finished'.tr,
                alignEnd: true,
                showEdit: canEdit,
                onEditTap: () => controller.showTimePickerDialog(
                  AppConstants.dialogIdentifier.selectShiftEndTime,
                  DateUtil.getDateTimeFromHHMM(controller.stopTime.value),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({
    required this.time,
    required this.label,
    this.alignEnd = false,
    this.showEdit = false,
    this.onEditTap,
  });

  final String time;
  final String label;
  final bool alignEnd;
  final bool showEdit;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: showEdit ? onEditTap : null,
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: primaryTextColor_(context),
                ),
              ),
              if (showEdit) ...[
                const SizedBox(width: 8),
                ImageUtils.setSvgAssetsImage(
                  path: Drawable.editPencilIcon,
                  width: 13,
                  height: 13,
                  color: primaryTextColor_(context),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: secondaryTextColor_(context),
          ),
        ),
      ],
    );
  }
}
