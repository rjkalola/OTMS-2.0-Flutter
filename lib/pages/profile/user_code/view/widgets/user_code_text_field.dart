import 'package:belcka/pages/profile/rates/controller/rates_controller.dart';
import 'package:belcka/pages/profile/user_code/controller/user_code_controller.dart';
import 'package:belcka/widgets/textfield/text_field_underline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class UserCodeTextField extends StatelessWidget {
  UserCodeTextField({super.key});

  final controller = Get.put(UserCodeController());

  @override
  Widget build(BuildContext context) {
    return TextFieldUnderline(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textEditingController: controller.userCodeController.value,
        hintText: "",
        labelText: 'user_code'.tr,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        isEnabled: true,
        onPressed: () {},
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 19,
        ),
        validator: MultiValidator([]),
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this

        ]);
  }
}

