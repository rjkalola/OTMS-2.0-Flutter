import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/pages/project/add_project/controller/add_project_controller.dart';
import 'package:otm_inventory/pages/teams/create_team/controller/create_team_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border_dark.dart';

class StatusTextField extends StatelessWidget {
  StatusTextField({super.key});

  final controller = Get.put(AddProjectController());

  @override
  Widget build(BuildContext context) {
    return TextFieldBorderDark(
      textEditingController: controller.statusController.value,
      hintText: 'status'.tr,
      labelText: 'status'.tr,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onValueChange: (value) {
        controller.isSaveEnable.value = true;
      },
      validator: MultiValidator([]),
    );
  }
}
