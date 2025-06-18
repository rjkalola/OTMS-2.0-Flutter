import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/profile/billing_info/view/widgets/last_name_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_info/view/widgets/middle_name_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_info/view/widgets/title_text.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';

import 'first_name_text_field.dart';

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
              // PrimaryBorderButton(
              //     buttonText: "Search",
              //     onPressed: () {},
              //     textColor: defaultAccentColor,
              //     borderRadius: 10,
              //     height: 30,
              //     borderColor: defaultAccentColor)
            ],
          ),
        ));
  }
}
