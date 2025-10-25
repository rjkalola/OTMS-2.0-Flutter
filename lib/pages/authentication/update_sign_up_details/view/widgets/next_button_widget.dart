import 'package:belcka/pages/authentication/update_sign_up_details/controller/update_sign_up_details_controller.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NextButtonWidget extends StatelessWidget {
  NextButtonWidget({super.key});

  final controller = Get.put(UpdateSignUpDetailsController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
          child: PrimaryButton(
            buttonText: 'update'.tr,
            onPressed: () {
              controller.onSubmitClick();
            },
          )),
    );
  }
}
