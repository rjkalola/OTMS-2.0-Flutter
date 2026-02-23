import 'package:belcka/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/profile/user_settings/controller/user_settings_controller.dart';
import 'package:belcka/pages/profile/user_settings/view/web_view_screen.dart';
import 'package:belcka/pages/profile/user_settings/view/widgets/build_dark_mode_item_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';

import '../../../../utils/app_storage.dart';
import '../../../common/model/user_info.dart';

class UserSettingsScreen extends StatelessWidget {
  UserSettingsScreen({Key? key}) : super(key: key);
  final controller = UserSettingsController();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: dashBoardBgColor_(context),
          child: SafeArea(
            child: Scaffold(
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'settings'.tr,
                isCenterTitle: false,
                bgColor: dashBoardBgColor_(context),
                isBack: true,
              ),
              backgroundColor: dashBoardBgColor_(context),
              body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? Center(
                        child: Text("no_internet_text".tr),
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
                            title: 'privacy_policy'.tr,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyWebViewScreen(
                                    url: 'https://belcka.com/privacy-policy',
                                    pageTitle: 'privacy_policy'.tr,
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildSettingItem(
                            icon: Icons.info_outline,
                            title: 'app_info'.tr,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyWebViewScreen(
                                    url: 'https://belcka.com/app-info',
                                    pageTitle: 'app_info'.tr,
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildSettingItem(
                            icon: Icons.swap_horiz,
                            title: 'switch_company'.tr,
                            onTap: () {
                              if (UserUtils.getLoginUserId() != 0) {
                                Get.toNamed(AppRoutes.switchCompanyScreen);
                              }
                            },
                          ),
                          // _buildSettingItem(
                          //   icon: Icons.delete_outline,
                          //   title: 'delete_account'.tr,
                          //   onTap: () {
                          //     Get.toNamed(AppRoutes.deleteAccountScreen);
                          //   },
                          //   isDestructive: true,
                          // ),
                          _buildSettingItem(
                            icon: Icons.logout,
                            title: 'logout'.tr,
                            onTap: () {
                              controller.showLogoutDialog();
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
    return CardViewDashboardItem(
        margin: EdgeInsets.fromLTRB(12, 6, 12, 6),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Icon(
            icon,
            color: isDestructive
                ? Colors.red
                : ThemeConfig.isDarkMode
                    ? Colors.white
                    : Colors.black,
            size: 32,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: isDestructive
                  ? Colors.red
                  : ThemeConfig.isDarkMode
                      ? Colors.white
                      : Colors.black,
            ),
          ),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ));
  }
}
