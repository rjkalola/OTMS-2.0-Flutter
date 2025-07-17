import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/profile/user_settings/controller/user_settings_controller.dart';
import 'package:otm_inventory/pages/profile/user_settings/view/web_view_screen.dart';
import 'package:otm_inventory/pages/profile/user_settings/view/widgets/build_dark_mode_item_widget.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

class UserSettingsScreen extends StatelessWidget {
  UserSettingsScreen({Key? key}) : super(key: key);
  final controller = UserSettingsController();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: dashBoardBgColor,
          child: SafeArea(
            child: Scaffold(
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'settings'.tr,
                isCenterTitle: false,
                bgColor: dashBoardBgColor,
                isBack: true,
              ),
              backgroundColor: dashBoardBgColor,
              body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? const Center(
                        child: Text("No Internet"),
                      )
                    : ListView(
                        children: [
                          // _buildSettingItem(
                          //   icon: Icons.language,
                          //   title: 'Language',
                          //   subtitle: 'English (United States)',
                          //   onTap: () {},
                          // ),
                          BuildDarkModeItemWidget(),
                          _buildSettingItem(
                            icon: Icons.description,
                            title: 'Privacy and Policy',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyWebViewScreen(
                                    url:
                                        'http://devsystem.belcka.com:3001/privacy-policy',
                                    pageTitle: "Privacy and Policy",
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildSettingItem(
                            icon: Icons.info_outline,
                            title: 'App Info',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyWebViewScreen(
                                    url:
                                        'http://devsystem.belcka.com:3001/app-info',
                                    pageTitle: "App Info",
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildSettingItem(
                            icon: Icons.swap_horiz,
                            title: 'Switch Company',
                            onTap: () {
                              Get.toNamed(AppRoutes.switchCompanyScreen);
                            },
                          ),
                          _buildSettingItem(
                            icon: Icons.delete_outline,
                            title: 'Delete Account',
                            onTap: () {
                              Get.toNamed(AppRoutes.deleteAccountScreen);
                            },
                            isDestructive: true,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ));
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
        margin: EdgeInsets.fromLTRB(12, 6, 12, 6),
        elevation: 2,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: backgroundColor,
        child: Container(
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              border: Border.all(width: 1, color: Colors.grey.shade200)),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Icon(
              icon,
              color: isDestructive ? Colors.red : Colors.black,
              size: 32,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: isDestructive ? Colors.red : Colors.black,
              ),
            ),
            subtitle: subtitle != null ? Text(subtitle) : null,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: onTap,
          ),
        ));
  }
}
