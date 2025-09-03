import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab2/controller/home_tab_controller.dart';
import 'package:belcka/res/colors.dart';

class LocationUpdateDivider extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  LocationUpdateDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isUpdateLocationDividerVisible.value
        ? Divider(
      thickness: 3,
      color: dividerColor_(context),
    )
        : Container(),);
  }
}
