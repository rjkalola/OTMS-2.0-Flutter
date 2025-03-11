import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/res/colors.dart';

class LocationUpdateDivider extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  LocationUpdateDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.isUpdateLocationDividerVisible.value
        ? Divider(
            thickness: 3,
            color: dividerColor,
          )
        : Container();
  }
}
