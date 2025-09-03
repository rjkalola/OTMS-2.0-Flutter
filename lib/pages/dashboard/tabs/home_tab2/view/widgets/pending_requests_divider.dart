import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab2/controller/home_tab_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/image_utils.dart';

class PendingRequestsDivider extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  PendingRequestsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.pendingRequestCount.value > 0
          ? Divider(
              thickness: 3,
              color: dividerColor_(context),
            )
          : Container(),
    );
  }
}
