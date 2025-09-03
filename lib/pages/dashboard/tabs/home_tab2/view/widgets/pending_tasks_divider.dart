import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/image_utils.dart';

class PendingTasksDivider extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  PendingTasksDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.dashboardResponse.value.taskCount ?? 0) > 0
          ? Divider(
              thickness: 3,
              color: dividerColor_(context),
            )
          : Container(),
    );
  }
}
