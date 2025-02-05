import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/otp_verification/controller/verify_otp_controller.dart';
import 'package:otm_inventory/widgets/footer_primary_button.dart';

class OtpSubmitButton extends StatelessWidget {
  OtpSubmitButton({super.key});

  final verifyOtpController = Get.put(VerifyOtpController());

  @override
  Widget build(BuildContext context) {
    return FooterPrimaryButton(
      buttonText: 'submit'.tr,
      onPressed: () {
        verifyOtpController.onSubmitOtpClick();
      },
    );
  }
}
