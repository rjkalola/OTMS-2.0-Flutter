import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/address_text_field.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/email_text_field.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/first_name_text_field.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/last_name_text_field.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/middle_name_text_field.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/phone_extension_text_field.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/phone_text_field.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/postcode_text_field.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/title_text.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';


class GeneralView extends StatelessWidget {
  GeneralView({super.key});
  final controller = Get.put(BillingInfoController());

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
              /*
              Visibility(
                visible: (controller.arguments == null) ,
                  child: MiddleNameTextField()
              ),
              */
              EmailTextField(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      // Bottom line under both TextField and button
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 0,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:
                            PostcodeTextField(),
                          ),

                          Visibility(
                            visible: false,
                            child: SizedBox(
                              height: 35,
                              width: 86,
                              child: OutlinedButton(
                                onPressed: () {
                                  controller.searchPostCode();
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color:defaultAccentColor_(context),
                                  width: 1.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  'search'.tr,
                                  style: TextStyle(color: defaultAccentColor_(context),fontSize: 15,fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                      PhoneTextfieldWidget(

                      )),
                ],
              ),
            ],
          ),
        ));
  }
}
