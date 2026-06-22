import 'package:belcka/pages/manage_forms/submit_form/controller/submit_form_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormSendButton extends StatelessWidget {
  FormSendButton({super.key});

  final controller = Get.find<SubmitFormController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        color: dashBoardBgColor_(context),
        child: ElevatedButton(
          onPressed:
              controller.isLoading.value ? null : controller.onSendPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: defaultAccentColor_(context),
            minimumSize: const Size(double.infinity, 52),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.send, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'send'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
