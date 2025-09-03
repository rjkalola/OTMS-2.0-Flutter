import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';

class UserScoreDivider extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  UserScoreDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => !StringHelper.isValidBoolValue(
              controller.dashboardResponse.value.isOwner)
          ? Divider(
              thickness: 3,
              color: dividerColor_(context),
            )
          : Container(),
    );
  }
}
