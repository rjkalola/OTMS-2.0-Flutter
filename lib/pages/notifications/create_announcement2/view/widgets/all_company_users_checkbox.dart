import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/checkbox/custom_checkbox.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/create_announcement_controller.dart';

class AllCompanyUsersCheckbox extends StatelessWidget {
  AllCompanyUsersCheckbox({super.key});

  final controller = Get.put(CreateAnnouncementController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Row(
        children: [
          CustomCheckbox(
              color: defaultAccentColor_(context),
              onValueChange: (value) {
                controller.isCompanyUsers.value =
                    !controller.isCompanyUsers.value;
              },
              mValue: controller.isCompanyUsers.value),
          GestureDetector(
            onTap: () {
              controller.isCompanyUsers.value =
                  !controller.isCompanyUsers.value;
            },
            child: TitleTextView(
              text: 'all_company_users'.tr,
            ),
          ),
        ],
      ),
    );
  }
}
