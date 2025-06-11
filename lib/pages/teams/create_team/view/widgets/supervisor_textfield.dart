import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/pages/teams/create_team/controller/create_team_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border_dark.dart';

class SupervisorTextField extends StatelessWidget {
  SupervisorTextField({super.key});

  final controller = Get.put(CreateTeamController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: TextFieldBorderDark(
        textEditingController: controller.supervisorController.value,
        hintText: 'select_supervisor'.tr,
        labelText: 'select_supervisor'.tr,
        keyboardType: TextInputType.name,
        isReadOnly: true,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        onValueChange: (value) {},
        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
        ]),
        onPressed: () {
          controller.showSelectSupervisorDialog();
        },
      ),
    );
  }
}
