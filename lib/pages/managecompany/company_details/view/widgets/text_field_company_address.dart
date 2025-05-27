import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/managecompany/company_details/controller/company_details_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

class TextFieldCompanyAddress extends StatelessWidget {
  TextFieldCompanyAddress({super.key});

  final controller = Get.put(CompanyDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: TextFieldBorder(
        textEditingController: controller.companyAddressController.value,
        hintText: 'company_address'.tr,
        labelText: 'company_address'.tr,
        // keyboardType: TextInputType.streetAddress,
        textInputAction: TextInputAction.newline,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onValueChange: (value) {},
        validator: MultiValidator([]),
      ),
    );
  }
}
