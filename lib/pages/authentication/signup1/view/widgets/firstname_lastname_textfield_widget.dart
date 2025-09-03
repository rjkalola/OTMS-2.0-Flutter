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



class FirstNameLastNameTextFieldWidget extends StatelessWidget {
  FirstNameLastNameTextFieldWidget({super.key});

  final controller = Get.put(SignUp1Controller());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: TextFieldBorder(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textEditingController: controller.firstNameController.value,
                hintText: 'first_name'.tr,
                labelText: 'first_name'.tr,
                maxLength: 30,
                keyboardType: TextInputType.name,
                isReadOnly: controller.isOtpViewVisible.value,
                textInputAction: TextInputAction.next,
                onValueChange: (value) {
                  controller.onValueChange();
                },
                onPressed: () {},
                validator: MultiValidator([
                  RequiredValidator(errorText: 'required_field'.tr),
                ]),
                inputFormatters: <TextInputFormatter>[
                  // for below version 2 use this
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                ]),
          ),
          // child: CustomTextFormField(
          //     textEditingController: controller.firstNameController.value,
          //     hintText: 'first_name'.tr,
          //     labelText: 'first_name'.tr,
          //     keyboardType: TextInputType.name,
          //     textInputAction: TextInputAction.next,
          //     validator: MultiValidator([
          //       RequiredValidator(errorText: 'required_field'.tr),
          //     ]),
          //     inputFormatters: <TextInputFormatter>[
          //       // for below version 2 use this
          //       FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
          //     ]),
          //     ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 1,
            child: TextFieldBorder(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textEditingController: controller.lastNameController.value,
                hintText: 'last_name'.tr,
                labelText: 'last_name'.tr,
                maxLength: 30,
                keyboardType: TextInputType.name,
                isReadOnly: controller.isOtpViewVisible.value,
                textInputAction: TextInputAction.next,
                onValueChange: (value) {
                  controller.onValueChange();
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context)
                      .requestFocus(controller.focusNodePhone.value);
                },
                onPressed: () {},
                validator: MultiValidator([
                  RequiredValidator(errorText: 'required_field'.tr),
                ]),
                inputFormatters: <TextInputFormatter>[
                  // for below version 2 use this
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                ]),
          ),
        ],
      ),
    );
  }
}
