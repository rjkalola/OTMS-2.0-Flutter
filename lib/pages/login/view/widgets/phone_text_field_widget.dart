import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/login/controller/login_controller.dart';
import 'package:otm_inventory/widgets/custom_text_form_field.dart';

class PhoneTextFieldWidget extends StatelessWidget {
   PhoneTextFieldWidget({super.key});
  final loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 18, 0),
        child: CustomTextFormField(
          textEditingController: loginController.phoneController.value,
          hintText: 'phone'.tr,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          validator: MultiValidator([
            RequiredValidator(errorText: 'required_field'.tr),
          ]),
            inputFormatters: <TextInputFormatter>[
              // for below version 2 use this
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(10),
            ]
        ),
      ),
    );
  }
}
