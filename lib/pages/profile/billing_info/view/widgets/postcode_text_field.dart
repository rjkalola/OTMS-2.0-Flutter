import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_underline_.dart';

class PostcodeTextField extends StatelessWidget {
  PostcodeTextField({super.key});

  final controller = Get.put(BillingInfoController());

  @override
  Widget build(BuildContext context) {
    return TextFieldUnderline(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textEditingController: controller.postcodeController.value,
        hintText: 'post_code'.tr,
        labelText: 'post_code'.tr,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onValueChange: (value) {
          //controller.onValueChange();
        },
        onPressed: () {},
        validator: MultiValidator([

        ]),
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this

        ]);
  }
}