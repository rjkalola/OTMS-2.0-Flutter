import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/image_utils.dart';

class PendingApprovalTasksDivider extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  PendingApprovalTasksDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.dashboardResponse.value.pendingApprovalCount ?? 0) > 0
        ? Divider(
      thickness: 3,
      color: dividerColor,
    )
        : Container(),);
  }
}
