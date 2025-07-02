import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:otm_inventory/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_underline_.dart';

class NameOnUtrTextField extends StatelessWidget {
  NameOnUtrTextField(
      {super.key,
        required this.controller,
        this.onValueChange,
        this.isReadOnly,
        this.isEnabled});

  final Rx<TextEditingController> controller;
  final ValueChanged<String>? onValueChange;
  final bool? isReadOnly;
  final bool? isEnabled;

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => TextFieldUnderline(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textEditingController: controller.value,
          hintText: 'name_on_utr'.tr,
          labelText: 'name_on_utr'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          isReadOnly: isReadOnly,
          onValueChange: onValueChange,
          isEnabled: isEnabled,
          onPressed: () {},
          validator: MultiValidator([

          ]),
          inputFormatters: <TextInputFormatter>[
            // for below version 2 use this

          ]),
    );
  }
}
