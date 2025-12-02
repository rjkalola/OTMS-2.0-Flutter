import 'package:belcka/pages/profile/my_profile_details/controller/my_profile_details_controller.dart';
import 'package:belcka/widgets/textfield/text_field_underline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class FirstNameFieldWidget extends StatelessWidget {
  FirstNameFieldWidget({super.key});
  final controller = Get.put(MyProfileDetailsController());

  @override
  Widget build(BuildContext context) {
    return TextFieldUnderline(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textEditingController: controller.firstNameController.value,
        hintText: 'first_name'.tr,
        labelText: 'first_name'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.done,
        isReadOnly: !controller.isComingFromMyProfile,
        isEnabled: controller.isComingFromMyProfile,
        onPressed: () {},
        validator: MultiValidator([

        ]),
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this

        ]);
  }
}