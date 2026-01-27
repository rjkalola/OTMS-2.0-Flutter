import 'package:belcka/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/widgets/textfield/text_field_phone_extension_widget.dart';

class PersonalInfoPhoneExtension extends StatelessWidget {
  PersonalInfoPhoneExtension({super.key});

  final controller = Get.put(PersonalInfoController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.fromLTRB(00, 0, 5, 18),
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
