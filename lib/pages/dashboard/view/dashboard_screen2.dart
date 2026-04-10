import 'dart:io';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/dashboard/controller/dashboard_controller.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:belcka/pages/dashboard/view/widgets/bottom_navigation_bar_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';

import '../../../utils/app_utils.dart';
import '../../../widgets/appbar/base_appbar.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final dashboardController = Get.put(DashboardController());
  DateTime? currentBackPressTime;
  var mTime;

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        final backNavigationAllowed = await onBackPress();
        if (backNavigationAllowed) {
          Get.delete<DashboardController>();
          Get.delete<HomeTabController>();
          if (Platform.isIOS) {
            exit(0);
          } else {
            SystemNavigator.pop();
          }
        }
      },
      /* onPopInvoked: (didPop) async {
        final backNavigationAllowed = await onBackPress();
        if (backNavigationAllowed) {
          if (Platform.isIOS) {
            exit(0);
          } else {
            SystemNavigator.pop();
          }
        }
      },*/
      child: Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
            child: Obx(() => ModalProgressHUD(
                inAsyncCall: dashboardController.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: AdaptiveScaffold(
                  minimizeBehavior: TabBarMinimizeBehavior.never,
                  // appBar: dashboardController.selectedIndex.value == 0
                  //     ? null
                  //     : BaseAppBar(
                  //         appBar: AppBar(),
                  //         title: dashboardController.title.value,
                  //         isCenterTitle: false,
                  //         isBack: true,
                  //         widgets: actionButtons(),
                  //       ),
                  body: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: PageView(
                      controller: dashboardController.pageController,
                      onPageChanged: dashboardController.onPageChanged,
                      physics: const NeverScrollableScrollPhysics(),
                      children: dashboardController.tabs,
                    ),
                  ),
                  //New bottom bar for liquid glass effect
                  bottomNavigationBar: AdaptiveBottomNavigationBar(
                    selectedItemColor: defaultAccentColor_(context),
                    unselectedItemColor: primaryTextColor_(context),
                    useNativeBottomBar: true,
                    items: [
                      AdaptiveNavigationDestination(
                        icon: 'house',
                        label: 'Home',
                      ),
                      AdaptiveNavigationDestination(
                        icon: 'bag',
                        label: 'Store',
                      ),
                      /*
                      AdaptiveNavigationDestination(
                        icon: 'bubble.left.and.bubble.right',
                        label: 'Chat',
                      ),
                      AdaptiveNavigationDestination(
                        icon: 'sparkles',
                        label: 'AI',
                      ),
                      */
                    ],
                    selectedIndex: 0,
                    onTap: (index) {
                      dashboardController.selectedIndex.value = index;
                      dashboardController.onItemTapped(index);
                    },
                  ),
                )))),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      // Visibility(
      //   visible: (dashboardController.selectedIndex.value == 0 &&
      //       !Get.put(StockListController()).isScanQrCode.value),
      //   child: InkWell(
      //       onTap: () {
      //         dashboardController.addMultipleStockQuantity();
      //       },
      //       child: Padding(
      //         padding: const EdgeInsets.only(right: 14),
      //         child: Text(
      //           "+${'add_stock'.tr}",
      //           style: const TextStyle(
      //               fontSize: 16,
      //               color: defaultAccentColor_(context),
      //               fontWeight: FontWeight.w500),
      //         ),
      //       )),
      // ),
      // Visibility(
      //   visible: (dashboardController.selectedIndex.value == 0 &&
      //       Get.put(StockListController()).isScanQrCode.value),
      //   child: InkWell(
      //       onTap: () {
      //         Get.put(StockListController())
      //             .getStockListApi(true, false, "", true, true);
      //       },
      //       child: Padding(
      //         padding: const EdgeInsets.only(right: 14),
      //         child: Text(
      //           'clear'.tr,
      //           style: const TextStyle(
      //               fontSize: 16,
      //               color: Colors.red,
      //               fontWeight: FontWeight.w500),
      //         ),
      //       )),
      // ),
    ];
  }

  Future<bool> onBackPress() {
    DateTime now = DateTime.now();
    if (mTime == null || now.difference(mTime) > const Duration(seconds: 2)) {
      mTime = now;
      AppUtils.showToastMessage('exit_warning'.tr);
      return Future.value(false);
    }

    return Future.value(true);
  }
}
