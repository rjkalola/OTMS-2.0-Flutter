import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/address_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/email_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/first_name_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/last_name_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/middle_name_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/phone_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/postcode_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/title_text.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import '../../../../authentication/login/view/widgets/phone_extension_field_widget.dart';

class GeneralView extends StatelessWidget {
  const GeneralView({super.key});

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
              TitleText(
                title: 'general'.tr,
              ),
              Row(children: [
                Flexible(flex: 1, child: FirstNameTextField()),
                SizedBox(
                  width: 14,
                ),
                Flexible(flex: 1, child: LastNameTextField())
              ]),
              SizedBox(
                height: 10,
              ),
              MiddleNameTextField(),
              EmailTextField(),
              Row(
                children: [
                  Expanded(
                      child:
                      PostcodeTextField(),),
                  const SizedBox(width: 8),
                  PrimaryButton(buttonText: 'search'.tr, onPressed: (){

                  })
                ],
              ),
              AddressTextField(),
              const SizedBox(height: 16),
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
                      PhoneTextfieldWidget()),
                ],
              ),

            ],
          ),
        ));
  }

}
