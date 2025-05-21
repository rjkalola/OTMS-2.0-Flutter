import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/signup1/controller/signup1_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

import '../../../../../widgets/validator/custom_field_validator.dart';

class PhoneTextFieldWidget extends StatelessWidget {
  PhoneTextFieldWidget({super.key});

  final controller = Get.put(SignUp1Controller());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 20, 18),
      child: TextFieldBorder(
          textEditingController: controller.phoneController.value,
          focusNode: controller.focusNodePhone.value,
          hintText: 'phone'.tr,
          labelText: 'phone'.tr,
          keyboardType: TextInputType.phone,
          isReadOnly: controller.isOtpViewVisible.value,
          onValueChange: (value) {
            controller.isPhoneNumberExist.value = false;
            controller.checkPhoneNumberExist();
          },
          onPressed: () {},
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: TextInputAction.done,
          validator: MultiValidator([
            RequiredValidator(errorText: 'required_field'.tr),
            CustomFieldValidator((value) {
              return value != null && !value.startsWith("0");
            }, errorText: 'error_phone_number_start_with_zero'.tr),
            CustomFieldValidator((value) {
              return value != null && value.length == 10;
            }, errorText: 'error_phone_number_contain_10_digits'.tr),
            CustomFieldValidator((value) {
              return value != null && !controller.isPhoneNumberExist.value;
            }, errorText: 'error_phone_number_already_exist'.tr),
          ]),
          inputFormatters: <TextInputFormatter>[
            // for below version 2 use this
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            LengthLimitingTextInputFormatter(10),
          ]),
    );
  }
}
