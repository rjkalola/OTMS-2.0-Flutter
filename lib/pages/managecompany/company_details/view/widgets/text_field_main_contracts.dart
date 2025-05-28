import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/managecompany/company_details/controller/company_details_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

class TextFieldMainContracts extends StatelessWidget {
  TextFieldMainContracts({super.key});

  final controller = Get.put(CompanyDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextFieldBorder(
        textEditingController: controller.mainContractsController.value,
        focusNode: controller.focusNodeMainContracts.value,
        hintText: 'main_contracts'.tr,
        labelText: 'main_contracts'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onValueChange: (value) {},
        validator: MultiValidator([

        ]),
      ),
    );
  }
}
