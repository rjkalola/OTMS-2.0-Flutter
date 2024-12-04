import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/widgets/bottom_navigation_bar_widget.dart';
import 'package:otm_inventory/pages/dashboard/widgets/main_drawer.dart';
import 'package:otm_inventory/res/colors.dart';

import '../../utils/app_utils.dart';
import '../../widgets/appbar/base_appbar.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final dashboardController = Get.put(DashboardController());
  DateTime? currentBackPressTime;
  var mTime;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        final backNavigationAllowed = await onBackPress();
        if (backNavigationAllowed) {
          if (Platform.isIOS) {
            exit(0);
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: SafeArea(
          child: Obx(() => Scaffold(
                backgroundColor: backgroundColor,
                appBar: BaseAppBar(
                  appBar: AppBar(),
                  title: dashboardController.title.value,
                  isCenterTitle: false,
                  isBack: true,
                  widgets: actionButtons(),
                ),
                drawer: MainDrawer(),
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
              ))),
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
      AppUtils.showSnackBarMessage('exit_warning'.tr);
      return Future.value(false);
    }

    return Future.value(true);
  }
}
