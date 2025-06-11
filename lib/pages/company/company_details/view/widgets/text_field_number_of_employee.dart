import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/company_details/controller/company_details_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

class TextFieldNumberOfEmployee extends StatelessWidget {
  TextFieldNumberOfEmployee({super.key});

  final controller = Get.put(CompanyDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextFieldBorder(
        textEditingController: controller.numberOfEmployeeController.value,
        focusNode: controller.focusNodeNumberOfEmployee.value,
        hintText: 'number_of_employee'.tr,
        labelText: 'number_of_employee'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.done,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onValueChange: (value) {},
        validator: MultiValidator([]),
        inputFormatters: <TextInputFormatter>[
          // FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
      ),
    );
  }
}
