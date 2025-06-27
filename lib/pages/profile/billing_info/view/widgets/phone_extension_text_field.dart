import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_phone_extension_widget.dart';
import 'package:otm_inventory/widgets/textfield/text_field_underline.dart';

class PhoneExtensionFieldWidget extends StatelessWidget {
  PhoneExtensionFieldWidget({super.key});

  final controller = Get.put(BillingInfoController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 15, 16),
      child: TextFieldPhoneExtensionWidget(
          mExtension: controller.mExtension.value,
          mFlag: controller.mFlag.value,
          onPressed: () {
            controller.showPhoneExtensionDialog();
          }),
    ));
  }
}