import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/profile/billing_details_new/controller/billing_details_new_controller.dart';
import 'package:belcka/widgets/textfield/text_field_underline.dart';


class PhoneTextfieldWidget extends StatelessWidget {
  PhoneTextfieldWidget({super.key});

  final controller = Get.put(BillingDetailsNewController());

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
              textEditingController: controller.phoneController.value,
              hintText: 'phone_number'.tr,
              labelText: 'phone_number'.tr,
              keyboardType: TextInputType.phone,
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

              ]),
        ),
      ],
    );
  }
}