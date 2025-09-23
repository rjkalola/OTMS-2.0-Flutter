import 'package:belcka/pages/profile/my_profile_details/controller/my_profile_details_controller.dart';
import 'package:belcka/widgets/validator/custom_field_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:belcka/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:belcka/widgets/textfield/text_field_underline_.dart';

class PhoneFieldWidget extends StatelessWidget {
  PhoneFieldWidget({super.key});

  final controller = Get.put(MyProfileDetailsController());

  @override
  Widget build(BuildContext context) {
    return TextFieldUnderline(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textEditingController: controller.phoneController.value,
        hintText: 'phone_number'.tr,
        labelText: 'phone_number'.tr,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        isReadOnly: false,
        isEnabled: true,
        onValueChange: (value) {
          //controller.onValueChange();
        },
        onPressed: () {},
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
        ]);
  }
}