import 'package:belcka/utils/phone_length_formatter.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/signup1/controller/signup1_controller.dart';
import 'package:belcka/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';

import '../../../../../widgets/validator/custom_field_validator.dart';

class PhoneNumberTextFieldCompanySignup extends StatelessWidget {
  PhoneNumberTextFieldCompanySignup({super.key});

  final controller = Get.put(CompanySignUpController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFieldBorder(
        textEditingController: controller.phoneController.value,
        hintText: 'phone'.tr,
        labelText: 'phone'.tr,
        keyboardType: TextInputType.phone,
        focusNode: controller.focusNodePhone.value,
        onValueChange: (value) {},
        onPressed: () {},
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.done,
        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
          // CustomFieldValidator((value) {
          //   return value != null && !value.startsWith("0");
          // }, errorText: 'error_phone_number_start_with_zero'.tr),
          CustomFieldValidator((value) {
            return value != null &&
                value.length ==
                    (StringHelper.getText(controller.phoneController.value)
                        .startsWith("0")
                        ? 11
                        : 10);
          }, errorText: 'error_phone_number_contain_10_digits'.tr),
        ]),
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          // LengthLimitingTextInputFormatter(10),
          PhoneLengthFormatter()
        ]),);
  }
}
