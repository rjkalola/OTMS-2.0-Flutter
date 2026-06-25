import 'package:belcka/pages/check_in/user_check_out/controller/user_check_out_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCheckOutSummaryCard extends StatelessWidget {
  UserCheckOutSummaryCard({super.key});

  final controller = Get.put(UserCheckOutController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isPriceWork = controller.isPriceWork.value;
      final isCheckedOut = !StringHelper.isEmptyString(
          controller.checkLogInfo.value.checkoutDateTime);

      String label;
      String value;
      if (isPriceWork) {
        label = 'total_amount'.tr;
        value =
            '£${controller.checkLogInfo.value.priceWorkTotalAmount ?? "0"}';
      } else {
        label = 'total_hours'.tr;
        value = isCheckedOut
            ? DateUtil.seconds_To_HH_MM(
                controller.checkLogInfo.value.totalWorkSeconds ?? 0)
            : 'working'.tr;
      }

      if (isPriceWork && !isCheckedOut) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$label:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: primaryTextColor_(context),
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: primaryTextColor_(context),
              ),
            ),
          ],
        ),
      );
    });
  }
}
