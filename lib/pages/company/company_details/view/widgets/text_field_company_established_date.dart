import 'package:belcka/pages/company/company_details/controller/company_details_controller.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class TextFieldCompanyEstablishedDate extends StatelessWidget {
  TextFieldCompanyEstablishedDate({super.key});

  final controller = Get.put(CompanyDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextFieldBorderDark(
        textEditingController: controller.companyEstablishDateController.value,
        hintText: 'company_established_Date'.tr,
        labelText: 'company_established_Date'.tr,
        isReadOnly: true,
        keyboardType: TextInputType.name,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onValueChange: (value) {},
        onPressed: () {
          controller.showDatePickerDialog(
              AppConstants.dialogIdentifier.establishedDate,
              controller.establishedDate,
              DateTime(1900),
              DateTime.now());
        },
        validator: MultiValidator([]),
      ),
    );
  }
}
