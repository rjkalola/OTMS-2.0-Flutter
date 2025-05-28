import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/managecompany/company_details/controller/company_details_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

class TextFieldCompanyName extends StatelessWidget {
  TextFieldCompanyName({super.key});

  final controller = Get.put(CompanyDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 16),
      child: TextFieldBorder(
        textEditingController: controller.companyNameController.value,
        hintText: 'company_name'.tr,
        labelText: 'company_name'.tr,
        maxLength: 50,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onValueChange: (value) {},
        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
        ]),
      ),
    );
  }
}
