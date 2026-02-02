import 'package:belcka/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/textfield/text_field_underline.dart';
import 'package:belcka/widgets/validator/custom_field_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class PersonalInfoEmailField extends StatelessWidget {
  final Rx<TextEditingController> controller;
  final bool isEnabled;
  final bool isReadOnly;
  final Function(String)? onChanged;

  PersonalInfoEmailField({
    Key? key,
    required this.controller,
    this.isEnabled = true,
    this.isReadOnly = false,
    this.onChanged,
  }) : super(key: key);

  final controllerP = Get.put(PersonalInfoController());

  @override
  Widget build(BuildContext context) {
    String value = controller.value.text;
    return TextFieldUnderline(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textEditingController: controller.value,
        hintText: 'email'.tr,
        labelText: 'email'.tr,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        isReadOnly: isReadOnly,
        isEnabled: isEnabled,
        onPressed: () {},
        validator: MultiValidator([
          CustomFieldValidator((value) {
            if (value == null || value.isEmpty){
              return true;
            }
            else{
              return (AppUtils().isEmailValid(value ?? ""));
            }
          }, errorText: 'Please enter a valid email address'.tr),
        ]),
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this

        ]);
  }
}
