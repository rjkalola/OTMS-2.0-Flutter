import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/pages/shifts/create_shift/controller/create_shift_controller.dart';
import 'package:otm_inventory/pages/teams/create_team/controller/create_team_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border_dark.dart';
import 'package:otm_inventory/widgets/textfield/text_field_underline.dart';

class ShiftNameTextField extends StatelessWidget {
  ShiftNameTextField({super.key});

  final controller = Get.put(CreateShiftController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: TextFieldUnderline(
        textEditingController: controller.shiftNameController.value,
        hintText: 'shift_name'.tr,
        labelText: 'shift_name'.tr,
        maxLength: 50,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.done,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onValueChange: (value) {
          controller.isSaveEnable.value = true;
        },
        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
        ]),
      ),
    );
  }
}
