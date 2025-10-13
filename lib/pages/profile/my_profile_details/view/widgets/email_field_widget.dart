import 'package:belcka/pages/profile/my_profile_details/controller/my_profile_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:belcka/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:belcka/widgets/textfield/text_field_underline_.dart';

class EmailFieldWidget extends StatelessWidget {
  EmailFieldWidget({super.key});

  final controller = Get.put(MyProfileDetailsController());

  @override
  Widget build(BuildContext context) {
    return TextFieldUnderline(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textEditingController: controller.emailController.value,
        hintText: 'email'.tr,
        labelText: 'email'.tr,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        isReadOnly: !controller.isComingFromMyProfile,
        isEnabled: controller.isComingFromMyProfile,
        onValueChange: (value) {
          //controller.onValueChange();
        },
        onPressed: () {},
        validator: MultiValidator([
          //RequiredValidator(errorText: 'required_field'.tr),
          EmailValidator(errorText: "Enter a valid email")
        ]),
        inputFormatters: <TextInputFormatter>[

        ]);
  }
}