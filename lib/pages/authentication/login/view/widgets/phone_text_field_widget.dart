import 'package:belcka/utils/phone_length_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/login/controller/login_controller.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';

class PhoneTextFieldWidget extends StatelessWidget {
  PhoneTextFieldWidget({super.key});

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 20, 18),
      child: TextFieldBorder(
          textEditingController: loginController.phoneController.value,
          hintText: 'phone'.tr,
          labelText: 'phone'.tr,
          keyboardType: TextInputType.phone,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onValueChange: (value) {
            // loginController.onValueChange();
          },
          isReadOnly: loginController.isOtpViewVisible.value,
          textInputAction: TextInputAction.done,
          validator: MultiValidator([
            RequiredValidator(errorText: 'required_field'.tr),
          ]),
          onPressed: () {},
          inputFormatters: <TextInputFormatter>[ 
            // for below version 2 use this
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            PhoneLengthFormatter()
            // LengthLimitingTextInputFormatter(10),
          ]),
    ),);
  }
}
