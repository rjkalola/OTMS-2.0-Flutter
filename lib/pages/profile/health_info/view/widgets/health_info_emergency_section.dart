import 'package:belcka/pages/profile/billing_info/view/widgets/title_text.dart';
import 'package:belcka/pages/profile/health_info/controller/health_info_controller.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/phone_length_formatter.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';
import 'package:belcka/widgets/textfield/text_field_phone_extension_widget.dart';
import 'package:belcka/widgets/validator/custom_field_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class HealthInfoEmergencySection extends StatelessWidget {
  HealthInfoEmergencySection({super.key});

  final controller = Get.put(HealthInfoController());

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(
              title: 'emergency_contact'.tr,
              fontSize: 18,
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFieldBorderDark(
                    textEditingController: controller.firstNameController.value,
                    hintText: 'first_name'.tr,
                    labelText: 'first_name'.tr,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: MultiValidator([]),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                      LengthLimitingTextInputFormatter(50),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFieldBorderDark(
                    textEditingController: controller.lastNameController.value,
                    hintText: 'last_name'.tr,
                    labelText: 'last_name'.tr,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: MultiValidator([]),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                      LengthLimitingTextInputFormatter(50),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: TextFieldBorderDark(
                textEditingController: controller.emailController.value,
                hintText: 'email'.tr,
                labelText: 'email'.tr,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: MultiValidator([
                  CustomFieldValidator(
                    (value) {
                      if (value == null || value.trim().isEmpty) return true;
                      return AppUtils().isEmailValid(value.trim());
                    },
                    errorText: 'enter_valid_email_address'.tr,
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Obx(
                      () => TextFieldPhoneExtensionWidget(
                        mExtension: controller.phoneExtension.value,
                        mFlag: controller.phoneFlag.value,
                        onPressed: () {
                          controller.showPhoneExtensionDialog();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 3,
                    child: TextFieldBorderDark(
                      textEditingController: controller.phoneController.value,
                      hintText: 'phone_number'.tr,
                      labelText: 'phone_number'.tr,
                      validator: MultiValidator([]),
                      maxLength: 15,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        PhoneLengthFormatter(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: TextFieldBorderDark(
                textEditingController: controller.postCodeController.value,
                hintText: 'postcode'.tr,
                validator: MultiValidator([]),
                labelText: 'postcode'.tr,
                maxLength: 20,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: TextFieldBorderDark(
                textEditingController: controller.addressController.value,
                hintText: 'address'.tr,
                validator: MultiValidator([]),
                labelText: 'address'.tr,
                maxLength: 200,
                keyboardType: TextInputType.streetAddress,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
