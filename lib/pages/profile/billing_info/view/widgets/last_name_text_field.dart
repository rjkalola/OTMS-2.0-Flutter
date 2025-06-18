import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_underline_.dart';

class LastNameTextField extends StatelessWidget {
  LastNameTextField({super.key});

  final controller = Get.put(PersonalInfoController());

  @override
  Widget build(BuildContext context) {
    return TextFieldUnderline(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textEditingController: controller.lastNameController.value,
        hintText: 'last_name'.tr,
        labelText: 'last_name'.tr,
        keyboardType: TextInputType.name,
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
