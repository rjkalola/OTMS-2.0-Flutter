import 'package:belcka/pages/profile/my_profile_details/controller/my_profile_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/login/controller/login_controller.dart';
import 'package:belcka/widgets/textfield/text_field_phone_extension_widget.dart';

class PhoneExtensionField extends StatelessWidget {
  PhoneExtensionField({super.key});

  final controller = Get.put(MyProfileDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 12, 0),
      child: TextFieldPhoneExtensionWidget(
          mExtension: controller.mExtension.value,
          mFlag: controller.mFlag.value,
          onPressed: () {
            controller.showPhoneExtensionDialog();
          }),
    ));
  }
}