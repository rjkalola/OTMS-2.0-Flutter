import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/signup1/controller/signup1_controller.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border2.dart';

import '../../../../../widgets/validator/custom_field_validator.dart';

class PhoneTextFieldWidget extends StatelessWidget {
  PhoneTextFieldWidget({super.key});

  final controller = Get.put(SignUp1Controller());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 0, 14, 18),
      child: TextFieldBorder(
          textEditingController: controller.phoneController.value,
          hintText: 'phone'.tr,
          labelText: 'phone'.tr,
          keyboardType: TextInputType.phone,
          onValueChange: (value) {
            controller.isPhoneNumberExist.value = false;
            // loginController.onValueChange();
            controller.checkPhoneNumberExist(
                controller.phoneController.value.text.toString().trim());
          },
          onPressed: () {},
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: TextInputAction.done,
          validator: MultiValidator([
            RequiredValidator(errorText: 'required_field'.tr),
            CustomFieldValidator((value) {
              bool isValid = value != null && !value.startsWith("0");
              return isValid;
            }, errorText: 'error_phone_number_start_with_zero'.tr),
            CustomFieldValidator((value) {
              bool isValid = value != null && value.length == 10;
              return isValid;
            }, errorText: 'error_phone_number_contain_10_digits'.tr),
            CustomFieldValidator((value) {
              bool isValid = value != null && value.length == 10;
              return isValid;
            }, errorText: 'error_phone_number_contain_10_digits'.tr),
            CustomFieldValidator((value) {
              bool isValid =
                  value != null && !controller.isPhoneNumberExist.value;
              return isValid;
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
