import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/details_of_work/controller/details_of_work_controller.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/controller/join_company_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

class TypeOfWorkTextField extends StatelessWidget {
  TypeOfWorkTextField({super.key});

  final controller = Get.put(DetailsOfWorkController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 26),
      child: TextFieldBorder(
          textEditingController: controller.typeOfWorkController.value,
          hintText: 'type_of_work'.tr,
          labelText: 'type_of_work'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.done,
          isReadOnly: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          validator: MultiValidator([]),
          onPressed: () {
            print("showCurrencyList");
          }),
    );
  }
}
