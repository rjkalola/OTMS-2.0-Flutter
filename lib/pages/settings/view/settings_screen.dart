import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/settings/controller/settings_controller.dart';
import 'package:otm_inventory/pages/settings/view/widgets/setting_item.dart';
import 'package:otm_inventory/pages/settings/view/widgets/setting_item_divider.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'settings'.tr,
            isCenterTitle: false,
            isBack: true,
          ),
          body: Obx(() {
            return ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget()
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            Divider(),
                            SizedBox(
                              height: 6,
                            ),
                            SettingItem(
                                onTap: () {
                                  controller.moveToScreen(
                                      AppRoutes.companyPermissionScreen);
                                },
                                title: 'company_permissions'.tr,
                                iconPath: Drawable.permissionIcon),
                            SettingItemDivider(),
                            SettingItem(
                                onTap: () {
                                  controller
                                      .moveToScreen(AppRoutes.shiftListScreen);
                                },
                                title: 'shifts'.tr,
                                iconPath: Drawable.clockPermissionIcon),
                          ],
                        ),
                      ));
          }),
        ),
      ),
    );
  }
}
