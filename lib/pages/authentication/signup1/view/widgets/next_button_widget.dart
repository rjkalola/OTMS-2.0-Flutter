import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/signup1/controller/signup1_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';

class NextButtonWidget extends StatelessWidget {
  NextButtonWidget({super.key});

  final controller = Get.put(SignUp1Controller());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get.toNamed(AppRoutes.signUp1Screen);
      },
      child: SizedBox(
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: PrimaryBorderButton(
              buttonText: 'next'.tr,
              textColor: defaultAccentColor,
              borderColor: defaultAccentColor,
              onPressed: () {
                controller.signUp();
              },
            )),
      ),
    );
  }
}
