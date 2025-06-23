import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/profile/billing_details/controller/billing_details_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_underline_.dart';

class EmailTextField extends StatelessWidget {
  EmailTextField({super.key});

  final controller = Get.put(BillingDetailsController());

  @override
  Widget build(BuildContext context) {
    return TextFieldUnderline(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textEditingController: controller.emailController.value,
        hintText: 'email'.tr,
        labelText: 'email'.tr,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onValueChange: (value) {
          //controller.onValueChange();
        },
        onPressed: () {},
        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
        ]),
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
        ]);
  }
}