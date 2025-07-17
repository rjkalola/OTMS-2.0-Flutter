import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';

class JoinCompanyRequestDivider extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  JoinCompanyRequestDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StringHelper.isValidBoolValue(
              controller.dashboardResponse.value.joinCompanyRequest)
          ? Divider(
              thickness: 3,
              color: dividerColor_(context),
            )
          : Container(),
    );
  }
}
