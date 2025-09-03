import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/company/company_details/controller/company_details_controller.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';

class TextFieldInsuranceNumber extends StatelessWidget {
  TextFieldInsuranceNumber({super.key});

  final controller = Get.put(CompanyDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextFieldBorder(
        textEditingController: controller.insuranceNumberController.value,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(controller.focusNodeNumberOfEmployee.value);
        },
        hintText: 'insurance_number'.tr,
        labelText: 'insurance_number'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onValueChange: (value) {},
        validator: MultiValidator([]),
      ),
    );
  }
}
