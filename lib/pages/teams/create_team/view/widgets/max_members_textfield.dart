import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:belcka/pages/teams/create_team/controller/create_team_controller.dart';
import 'package:belcka/pages/teams/create_team/view/widgets/member_limit_textfield.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class MaxMembersTextField extends StatelessWidget {
  MaxMembersTextField({super.key});

  final controller = Get.put(CreateTeamController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryTextView(
            text: 'max_members'.tr,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(height: 8),
          MemberLimitTextField(
            controller: controller.maxMembersController.value,
            hintText: 'max'.tr,
            onChanged: controller.onMaxMembersChanged,
            onIncrementTap: controller.incrementMaxMembers,
            onDecrementTap: controller.decrementMaxMembers,
          ),
        ],
      ),
    );
  }
}
