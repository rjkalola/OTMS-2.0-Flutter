import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/signup1/controller/signup1_controller.dart';
import 'package:belcka/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:belcka/pages/profile/personal_info/view/personal_info_screen.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';
import 'package:belcka/widgets/textfield/text_field_underline.dart';


class PersonalInfoBankSortcodeTextFieldWidget extends StatelessWidget {
  PersonalInfoBankSortcodeTextFieldWidget({super.key});

  final controller = Get.put(PersonalInfoController());

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: TextFieldUnderline(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textEditingController: controller.sortCodeController.value,
              hintText: 'sort_code'.tr,
              labelText: 'sort_code'.tr,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              onValueChange: (value) {
                //controller.onValueChange();
              },
              onPressed: () {

              },
              validator: MultiValidator([
                RequiredValidator(errorText: 'required_field'.tr),
              ]),
              inputFormatters: <TextInputFormatter>[
                // for below version 2 use this
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
              ]),
        ),
      ],
    );
  }
}