import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/pages/company/joincompany/controller/join_company_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

class CurrencyTextFieldCompanySignUp extends StatelessWidget {
  CurrencyTextFieldCompanySignUp({super.key});

  final controller = Get.put(CompanySignUpController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 26),
      child: TextFieldBorder(
          textEditingController: controller.currencyController.value,
          hintText: 'currency'.tr,
          labelText: 'currency'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.done,
          isReadOnly: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          validator: MultiValidator([]),
          onPressed: () {
            print("showCurrencyList");
            controller.showCurrencyList();
          }),
    );
  }
}
