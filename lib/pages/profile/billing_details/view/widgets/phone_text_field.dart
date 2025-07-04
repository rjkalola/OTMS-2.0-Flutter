import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/signup1/controller/signup1_controller.dart';
import 'package:otm_inventory/pages/profile/billing_details/controller/billing_details_controller.dart';
import 'package:otm_inventory/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:otm_inventory/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:otm_inventory/pages/profile/personal_info/view/personal_info_screen.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';
import 'package:otm_inventory/widgets/textfield/text_field_underline.dart';

import '../../../../../widgets/custom_text_form_field.dart';

class PhoneTextfieldWidget extends StatelessWidget {
  PhoneTextfieldWidget({super.key});

  final controller = Get.put(BillingDetailsController());

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