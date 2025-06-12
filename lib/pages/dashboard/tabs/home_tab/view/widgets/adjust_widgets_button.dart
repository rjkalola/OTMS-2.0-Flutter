import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:get/get.dart';

class AdjustWidgetsButton extends StatelessWidget {
  AdjustWidgetsButton({super.key});

  final controller = Get.put(HomeTabController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 12, 8),
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
            onPressed: () {
              controller.moveToScreen(appRout: AppRoutes.adjustWidgetsScreen);
            },
            icon: ImageUtils.setSvgAssetsImage(
                path: Drawable.editingIcon, width: 30, height: 30)),
      ),
    );
  }
}
