import 'package:belcka/pages/check_in/user_work_log_request/controller/user_work_log_request_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkLogRequestHeader extends StatelessWidget {
  WorkLogRequestHeader({super.key});

  final controller = Get.put(UserWorkLogRequestController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = controller.workLogInfo.value.status ?? 0;

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            Text(
              'my_shift'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: primaryTextColor_(context),
              ),
            ),
            if (!StringHelper.isEmptyString(controller.statusLabel)) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppUtils.getStatusColor(status)),
                ),
                child: Text(
                  controller.statusLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppUtils.getStatusColor(status),
                  ),
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
            color: secondaryTextColor_(context),
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
