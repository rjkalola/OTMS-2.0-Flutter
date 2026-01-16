import 'package:belcka/pages/company/company_details/controller/company_details_controller.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class TextFieldCompanyAddress extends StatelessWidget {
  TextFieldCompanyAddress({super.key});

  final controller = Get.put(CompanyDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
      child: TextFieldBorderDark(
        textEditingController: controller.companyAddressController.value,
        focusNode: controller.focusNodeAddress.value,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(controller.focusNodePhone.value);
        },
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
