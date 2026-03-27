import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/signup1/controller/signup1_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';

class EmailTextFieldWidget extends StatelessWidget {
  EmailTextFieldWidget({super.key});

  final controller = Get.put(SignUp1Controller());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20,bottom: 20),
      child: TextFieldBorder(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textEditingController: controller.emailController.value,
          hintText: 'email'.tr,
          labelText: 'email'.tr,
          maxLength: 50,
          keyboardType: TextInputType.emailAddress,
          isReadOnly: controller.isOtpViewVisible.value,
          textInputAction: TextInputAction.done,
          onValueChange: (value) {
            controller.onValueChange();
          },
          onPressed: () {},
          validator: MultiValidator([
            RequiredValidator(errorText: 'required_field'.tr),
            EmailValidator(errorText: "enter_valid_email_address".tr),
          ]),
          inputFormatters: <TextInputFormatter>[
            // for below version 2 use this
            LengthLimitingTextInputFormatter(50),
          ]),
    );
  }
}
