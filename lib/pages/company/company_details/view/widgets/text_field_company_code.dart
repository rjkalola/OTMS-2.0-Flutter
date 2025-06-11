import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/company_details/controller/company_details_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

class TextFieldCompanyCode extends StatelessWidget {
  TextFieldCompanyCode({super.key});

  final controller = Get.put(CompanyDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextFieldBorder(
        textEditingController: controller.companyCodeController.value,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(controller.focusNodeAddress.value);
        },
        hintText: 'company_code'.tr,
        labelText: 'company_code'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onValueChange: (value) {},
        validator: MultiValidator([]),
      ),
    );
  }
}
