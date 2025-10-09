import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:belcka/pages/project/add_address/controller/add_address_controller.dart';
import 'package:belcka/pages/project/add_project/controller/add_project_controller.dart';
import 'package:belcka/pages/teams/create_team/controller/create_team_controller.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';

class SiteAddressTextField extends StatelessWidget {
  SiteAddressTextField({super.key});

  final controller = Get.put(AddAddressController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: !StringHelper.isEmptyString(
            controller.siteAddressController.value.text),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: TextFieldBorderDark(
            textEditingController: controller.siteAddressController.value,
            hintText: 'enter_address'.tr,
            labelText: 'enter_address'.tr,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onValueChange: (value) {
              controller.isSaveEnable.value =
                  controller.siteAddressController.value.text.trim().isNotEmpty;
            },
            validator: MultiValidator([
              RequiredValidator(errorText: 'required_field'.tr),
            ]),
          ),
        ),
      ),
    );
  }
}
