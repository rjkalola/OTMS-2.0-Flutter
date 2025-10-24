import 'package:belcka/pages/users/invite_user/controller/invite_user_controller.dart';
import 'package:belcka/widgets/textfield/text_field_phone_extension_widget_dark.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneExtensionFieldWidget extends StatelessWidget {
  PhoneExtensionFieldWidget({super.key});

  final controller = Get.put(InviteUserController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 5, 18),
          child: TextFieldPhoneExtensionWidgetDark(
              mExtension: controller.mExtension.value,
              mFlag: controller.mFlag.value,
              onPressed: () {
                controller.showPhoneExtensionDialog();
              }),
        ));
  }
}
