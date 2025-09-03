import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/profile/billing_details_new/controller/billing_details_new_controller.dart';
import 'package:belcka/widgets/textfield/text_field_underline_.dart';

class MiddleNameTextField extends StatelessWidget {
  MiddleNameTextField({super.key});

  final controller = Get.put(BillingDetailsNewController());

  @override
  Widget build(BuildContext context) {
    return TextFieldUnderline(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textEditingController: controller.middleNameController.value,
        hintText: 'middle_name'.tr,
        labelText: 'middle_name'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        onValueChange: (value) {
          //controller.onValueChange();
        },
        onPressed: () {},
        validator: MultiValidator([

        ]),
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this
        ]);
  }
}
