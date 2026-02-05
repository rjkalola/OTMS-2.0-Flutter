import 'package:belcka/pages/authentication/update_sign_up_details/controller/update_sign_up_details_controller.dart';
import 'package:belcka/utils/phone_length_formatter.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class PhoneTextFieldWidget extends StatelessWidget {
  PhoneTextFieldWidget({super.key});

  final controller = Get.put(UpdateSignUpDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 20, 18),
      child: Obx(() => TextFieldBorder(
          textEditingController: controller.phoneController.value,
          hintText: 'phone'.tr,
          labelText: 'phone'.tr,
          keyboardType: TextInputType.phone,
          onValueChange: (value) {},
          isEnable: false,
          onPressed: () {},
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: TextInputAction.done,
          validator: MultiValidator([]),
          inputFormatters: <TextInputFormatter>[
            // for below version 2 use this
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            // LengthLimitingTextInputFormatter(10),
            PhoneLengthFormatter()
          ]),),
    );
  }
}
