import 'package:belcka/pages/check_in/user_stop_shift/controller/user_stop_shift_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShiftDoneFooter extends StatelessWidget {
  ShiftDoneFooter({super.key});

  final controller = Get.put(UserStopShiftController());

  static const Color _doneColor = Color(0xFF32A852);
  static const Color _stopColor = Color(0xFFFF484B);

  List<BoxShadow> _glowShadow(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.62),
          blurRadius: 10,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isWorking = controller.isWorking.value;

      return Container(
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          border: Border.all(color: Colors.black.withOpacity(0.08)),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _glowShadow(isWorking ? _stopColor : _doneColor),
                ),
                child: ElevatedButton(
                  onPressed: isWorking
                      ? controller.userStopWorkApi
                      : controller.onBackPress,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: isWorking ? _stopColor : _doneColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    isWorking ? 'stop_shift'.tr : 'done'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
