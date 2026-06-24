import 'package:belcka/pages/check_in/user_stop_shift/controller/user_stop_shift_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShiftTimesCard extends StatelessWidget {
  ShiftTimesCard({super.key});

  final controller = Get.put(UserStopShiftController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
              time: controller.startTime.value,
              label: 'started'.tr,
            )),
            Icon(Icons.arrow_forward_rounded,
                color: secondaryTextColor_(context), size: 22),
            Expanded(
                child: _TimeColumn(
              time: controller.stopTime.value,
              label: 'finished'.tr,
              alignEnd: true,
            )),
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
  });

  final String time;
  final String label;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment:
      //     alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: primaryTextColor_(context),
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
