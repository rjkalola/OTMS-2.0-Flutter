import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/teams/create_team/controller/create_team_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class AddTeamMember extends StatelessWidget {
  AddTeamMember({super.key});

  final controller = Get.put(CreateTeamController());

  @override
  Widget build(BuildContext context) {
    /* return Padding(
      padding: EdgeInsets.fromLTRB(10, 14, 10, 0),
      child: CardViewDashboardItem(
          child: Container(
        padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
        width: double.infinity,
        child: PrimaryTextView(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: primaryTextColor,
          text: 'add_team_members'.tr,
        ),
      )),
    );*/
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(16, 25, 16, 6),
        width: 230,
        child: PrimaryBorderButton(
            buttonText: "+ ${'add_team_members'.tr}",
            onPressed: () {
              print("PrimaryBorderButton");
              controller.showSelectTeamMemberListDialog();
            },
            textColor: defaultAccentColor,
            borderRadius: 45,
            borderColor: defaultAccentColor),
      ),
    );
  }
}
