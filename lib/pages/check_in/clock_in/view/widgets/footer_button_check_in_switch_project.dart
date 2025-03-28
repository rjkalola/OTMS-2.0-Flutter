import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_controller.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';

class FooterButtonCheckInSwitchProject extends StatelessWidget {
  FooterButtonCheckInSwitchProject({super.key});

  final controller = Get.put(ClockInController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: PrimaryButton(
              buttonText: 'switch_project'.tr,
              onPressed: () {},
              color: Color(0xffD5DDF2),
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontColor: Color(0xff0353C1),
              borderRadius: 10,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: PrimaryButton(
              buttonText: 'check_in_'.tr,
              onPressed: () {},
              color: Color(0xff2DC75C),
              fontWeight: FontWeight.w500,
              fontSize: 16,
              borderRadius: 10,
            ),
          ),
        ],
      ),
    );
  }
}
