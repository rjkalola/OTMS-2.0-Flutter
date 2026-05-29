import 'package:belcka/pages/users/user_list/controller/user_list_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersWorkingCountWidget extends StatelessWidget {
  const UsersWorkingCountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserListController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          const Spacer(),
          Obx(
            () => Text(
              '${controller.getDisplayWorkingMemberCount()}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: defaultAccentColor_(context),
              ),
            ),
          ),
          Obx(
            () => Text(
              '/${controller.getDisplayTotalUsersCount()} ${'working'.tr}',
              style: TextStyle(
                fontSize: 14,
                color: secondaryTextColor_(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
