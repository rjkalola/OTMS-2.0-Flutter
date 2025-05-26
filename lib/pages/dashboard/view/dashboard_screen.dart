import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/dashboard/controller/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/pages/dashboard/view/widgets/bottom_navigation_bar_widget.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';

import '../../../utils/app_utils.dart';
import '../../../widgets/appbar/base_appbar.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final dashboardController = Get.put(DashboardController());
  DateTime? currentBackPressTime;
  var mTime;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: dashBoardBgColor,
        statusBarIconBrightness: Brightness.dark));
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
        color: dashBoardBgColor,
        child: SafeArea(
            child: Obx(() => ModalProgressHUD(
                inAsyncCall: dashboardController.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: Scaffold(
                  backgroundColor: dashBoardBgColor,
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
                  bottomNavigationBar: BottomNavigationBarWidget(),
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
      //               color: defaultAccentColor,
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
