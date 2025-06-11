import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/signup1/controller/signup1_controller.dart';
import 'package:otm_inventory/pages/company/company_details/controller/company_details_controller.dart';
import 'package:otm_inventory/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

import '../../../../../widgets/validator/custom_field_validator.dart';

class TextFieldPhoneNumber extends StatelessWidget {
  TextFieldPhoneNumber({super.key});

  final controller = Get.put(CompanyDetailsController());

  @override
  Widget build(BuildContext context) {
    return TextFieldBorder(
        textEditingController: controller.phoneController.value,
        hintText: 'phone'.tr,
        labelText: 'phone'.tr,
        keyboardType: TextInputType.phone,
        focusNode: controller.focusNodePhone.value,
        onValueChange: (value) {},
        onPressed: () {},
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.next,
        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
          CustomFieldValidator((value) {
            return value != null && !value.startsWith("0");
          }, errorText: 'error_phone_number_start_with_zero'.tr),
          CustomFieldValidator((value) {
            return value != null && value.length == 10;
          }, errorText: 'error_phone_number_contain_10_digits'.tr),
        ]),
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          LengthLimitingTextInputFormatter(10),
        ]);
  }
}
