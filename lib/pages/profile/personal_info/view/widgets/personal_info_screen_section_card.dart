import 'package:belcka/pages/profile/billing_info/view/widgets/email_text_field.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/first_name_text_field.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/last_name_text_field.dart';
import 'package:belcka/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:belcka/pages/profile/personal_info/view/widgets/personal_info_email_field.dart';
import 'package:belcka/pages/profile/personal_info/view/widgets/personal_info_phone_extension.dart';
import 'package:belcka/pages/profile/personal_info/view/widgets/personal_info_phone_textfield.dart';
import 'package:belcka/pages/profile/personal_info/view/widgets/user_code_text_field.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalInfoSectionCard extends StatelessWidget {
  PersonalInfoSectionCard({
    super.key,
    this.isEnabled = true,
  });

  final bool isEnabled;
  final controller = Get.put(PersonalInfoController());

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEnabled,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: CardViewDashboardItem(
          margin: EdgeInsets.fromLTRB(12, 6, 12, 6),
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: FirstNameTextField(
                        controller: controller.firstNameController,
                      ),
                    ),
                    SizedBox(width: 14),
                    Flexible(
                      flex: 1,
                      child: LastNameTextField(
                        controller: controller.lastNameController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: PersonalInfoPhoneExtension(),
                    ),
                    Flexible(
                      flex: 3,
                      child: PersonalInfoPhoneTextfield(),
                    ),
                  ],
                ),
                PersonalInfoEmailField(
                  controller: controller.emailController,
                ),
                SizedBox(height: 16),
                UserCodeTextField(
                  controller: controller.userCodeController,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}