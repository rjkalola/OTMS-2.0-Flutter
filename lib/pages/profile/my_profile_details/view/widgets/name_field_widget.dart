import 'package:belcka/pages/profile/my_profile_details/controller/my_profile_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:belcka/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:belcka/widgets/textfield/text_field_underline_.dart';

class NameFieldWidget extends StatelessWidget {
  NameFieldWidget({super.key});

  final controller = Get.put(MyProfileDetailsController());

  @override
  Widget build(BuildContext context) {
    return TextFieldUnderline(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textEditingController: controller.nameController.value,
        hintText: 'name'.tr,
        labelText: 'name'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        isReadOnly: true,
        isEnabled: false,
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