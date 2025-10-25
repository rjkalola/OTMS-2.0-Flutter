import 'package:belcka/pages/authentication/update_sign_up_details/controller/update_sign_up_details_controller.dart';
import 'package:belcka/widgets/textfield/text_field_phone_extension_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneExtensionFieldWidget extends StatelessWidget {
  PhoneExtensionFieldWidget({super.key});

  final controller = Get.put(UpdateSignUpDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 5, 18),
          child: TextFieldPhoneExtensionWidget(
              mExtension: controller.mExtension.value,
              mFlag: controller.mFlag.value,
              enabled: false,
              onPressed: () {
                // if(!controller.isOtpViewVisible.value){
                //   controller.showPhoneExtensionDialog();
                // }
              }),
        ));
  }
}
