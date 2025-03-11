import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';

class UserScoreDivider extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  UserScoreDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return !StringHelper.isValidBoolValue(
            controller.dashboardResponse.value.isOwner)
        ? Divider(
            thickness: 3,
            color: dividerColor,
          )
        : Container();
  }
}
