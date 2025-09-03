import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/teams/create_team/controller/create_team_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

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
          color: primaryTextColor_(context),
          text: 'add_team_members'.tr,
        ),
      )),
    );*/
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () {
          controller.showSelectTeamMemberListDialog();
        },
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.fromLTRB(16, 28, 20, 6),
          child: PrimaryTextView(
              text: "+ ${'add_team_members'.tr}",
              fontSize: 16,
              color: defaultAccentColor_(context),
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
