import 'package:belcka/pages/check_in/user_stop_shift/controller/user_stop_shift_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShiftWorkedTimeCard extends StatelessWidget {
  ShiftWorkedTimeCard({super.key});

  final controller = Get.put(UserStopShiftController());

  static const Color _cardBlue = Color(0xFFE8F3FC);
  static const Color _timeNavy = Color(0xFF1A2B4A);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
        decoration: BoxDecoration(
          color: _cardBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'worked_time'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: secondaryTextColor_(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    controller.formattedWorkedTime,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: _timeNavy,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              Drawable.stopShiftBlueClockIcon,
              width: 88,
              height: 88,
              fit: BoxFit.contain,
            ),
          ],
        ),
      );
    });
  }
}
