import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/controller/join_company_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

class SelectYourRoleView extends StatelessWidget {
  SelectYourRoleView({super.key});

  final controller = Get.put(JoinCompanyController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 26),
      child: TextFieldBorder(
          textEditingController: controller.selectYourRoleController.value,
          hintText: 'select_your_role'.tr,
          labelText: 'select_your_role'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          isReadOnly: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          validator: MultiValidator([]),
          onPressed: () {
            controller.showCompanyListList();
          }),
    );
  }
}
