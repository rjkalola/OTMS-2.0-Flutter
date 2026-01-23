import 'package:belcka/pages/profile/billing_info/view/widgets/email_text_field.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/first_name_text_field.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/last_name_text_field.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/phone_text_field.dart';
import 'package:belcka/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:belcka/pages/profile/personal_info/view/widgets/user_code_text_field.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../authentication/signup1/view/widgets/phone_extension_field_widget.dart';

class PersonalInfoSectionCard extends StatelessWidget {
  PersonalInfoSectionCard({super.key});
  final controller = Get.put(PersonalInfoController());

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
        margin: EdgeInsets.fromLTRB(12, 6, 12, 6),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16,),
              Row(children: [
                //First name
                Flexible(flex: 1, child: FirstNameTextField(
                    controller: controller.firstNameController
                )),
                SizedBox(
                  width: 14,
                ),
                //Last name
                Flexible(flex: 1, child: LastNameTextField(
                  controller: controller.lastNameController,
                ))
              ]),
              SizedBox(height: 16,),
              //Phone
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child:
                    PhoneExtensionFieldWidget(),
                  ),
                  Flexible(
                      flex: 3,
                      child:
                      PhoneTextfieldWidget(

                      )),
                ],
              ),
              //Email
              EmailTextField(
                controller: controller.emailController,
              ),
              SizedBox(height: 16,),
              //Address
              UserCodeTextField(
                controller: controller.userCodeController,
              ),
              SizedBox(height: 16),
            ],
          ),
        ));
  }
}