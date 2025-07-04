import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/joincompany/controller/join_company_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

class SelectCompanyView extends StatelessWidget {
  SelectCompanyView({super.key});

  final controller = Get.put(JoinCompanyController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 26),
      child: TextFieldBorder(
          textEditingController: controller.selectCompanyController.value,
          hintText: 'select_company'.tr,
          labelText: 'select_company'.tr,
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
