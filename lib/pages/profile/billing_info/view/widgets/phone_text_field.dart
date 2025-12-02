import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/signup1/controller/signup1_controller.dart';
import 'package:belcka/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:belcka/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:belcka/pages/profile/personal_info/view/personal_info_screen.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';
import 'package:belcka/widgets/textfield/text_field_underline.dart';
import 'package:belcka/widgets/validator/custom_field_validator.dart';


class PhoneTextfieldWidget extends StatelessWidget {
  PhoneTextfieldWidget({super.key});

  final controller = Get.put(BillingInfoController());

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: TextFieldUnderline(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textEditingController: controller.phoneController.value,
              hintText: 'phone_number'.tr,
              labelText: 'phone_number'.tr,
              keyboardType: TextInputType.phone,
              isReadOnly: false,
              isEnabled: true,
              textInputAction: TextInputAction.done,
              onValueChange: (value) {
                //controller.onValueChange();
              },
              onPressed: () {

              },
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
        ),
      ],
    );
  }
}