import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/user_stop_shift/controller/user_stop_shift_controller.dart';
import 'package:belcka/widgets/PrimaryButton.dart';

class UserStopShiftButton extends StatelessWidget {
  UserStopShiftButton({super.key});

  final controller = Get.put(UserStopShiftController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
      child: PrimaryButton(
        buttonText: 'stop_shift'.tr,
        onPressed: () {
          controller.userStopWorkApi();
        },
        color: Colors.red,
      ),
    );
  }
}
