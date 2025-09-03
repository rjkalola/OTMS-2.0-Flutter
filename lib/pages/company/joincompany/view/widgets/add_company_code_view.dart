import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/company/joincompany/controller/join_company_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';

class AddCompanyCode extends StatelessWidget {
  AddCompanyCode({super.key});

  final controller = Get.put(JoinCompanyController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 26),
      child: Row(
        children: [
          Expanded(
            child: TextFieldBorder(
                textEditingController:
                    controller.addCompanyCodeController.value,
                hintText: 'add_company_code'.tr,
                labelText: 'add_company_code'.tr,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                validator: MultiValidator([]),
                onPressed: () {}),
          ),
          SizedBox(
            width: 12,
          ),
          PrimaryBorderButton(
              buttonText: 'search'.tr,
              onPressed: () {
                controller.onClickSearch();
              },
              fontColor: defaultAccentColor_(context),
              borderColor: defaultAccentColor_(context))
        ],
      ),
    );
  }
}
