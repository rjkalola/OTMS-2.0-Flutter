import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/pages/project/add_project/controller/add_project_controller.dart';
import 'package:otm_inventory/pages/teams/create_team/controller/create_team_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border_dark.dart';

class BudgetTextField extends StatelessWidget {
  BudgetTextField({super.key});

  final controller = Get.put(AddProjectController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFieldBorderDark(
        textEditingController: controller.budgetController.value,
        hintText: "${'budget'.tr} (£)",
        labelText: "${'budget'.tr} (£)",
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onValueChange: (value) {
          controller.isSaveEnable.value = true;
        },
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        validator: MultiValidator([]),
      ),
    );
  }
}
