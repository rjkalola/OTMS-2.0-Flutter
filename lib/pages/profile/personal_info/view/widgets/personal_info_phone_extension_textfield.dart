import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/widgets/textfield/text_field_phone_extension_widget.dart';
import 'package:belcka/widgets/textfield/text_field_underline.dart';
import 'package:belcka/pages/profile/personal_info/controller/personal_info_controller.dart';

class PersonalInfoPhoneExtensionFieldWidget extends StatelessWidget {
  PersonalInfoPhoneExtensionFieldWidget({super.key});

  final controller = Get.put(PersonalInfoController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.fromLTRB(0, 25, 15, 18),
      child: TextFieldPhoneExtensionWidget(
          mExtension: controller.mExtension.value,
          mFlag: controller.mFlag.value,
          onPressed: () {
            //controller.showPhoneExtensionDialog();
          }),
    ));
  }
}