import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/signup1/controller/signup1_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_phone_extension_widget.dart';

class PhoneExtensionFieldWidget extends StatelessWidget {
  PhoneExtensionFieldWidget({super.key});

  final controller = Get.put(SignUp1Controller());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 5, 18),
          child: TextFieldPhoneExtensionWidget(
              mExtension: controller.mExtension.value,
              mFlag: controller.mFlag.value,
              onPressed: () {
                if(!controller.isOtpViewVisible.value){
                  controller.showPhoneExtensionDialog();
                }
              }),
        ));
  }
}
