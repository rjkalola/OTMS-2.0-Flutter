import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otm_inventory/pages/dashboard/tabs/more_tab/more_tab.dart';
import 'package:otm_inventory/pages/profile/my_account/controller/my_account_repository.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/user_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';
import '../../../dashboard/tabs/home_tab2/view/home_tab.dart';

class MyAccountController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _api = MyAccountRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final title = 'dashboard'.tr.obs;
  final selectedIndex = 0.obs;
  late final PageController pageController;
  final tabs = <Widget>[
    // StockListScreen(),
    HomeTab(),
    // ProfileTab(),
    MoreTab(),
    MoreTab(),
    MoreTab(),
    MoreTab(),
  ];

  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.receipt, 'title': 'billing'.tr},
    {'icon': Icons.health_and_safety_outlined, 'title': 'health_info'.tr},
    {'icon': Icons.favorite_border, 'title': 'health_safety'.tr},
    {'icon': Icons.request_page_outlined, 'title': 'my_requests'.tr},
    {'icon': Icons.insert_drive_file_outlined, 'title': 'documents'.tr},
    {'icon': Icons.beach_access_outlined, 'title': 'my_leaves'.tr},
    {'icon': Icons.badge_outlined, 'title': 'digital_id'.tr},
    {'icon': Icons.home_outlined, 'title': 'rent'.tr},
    {'icon': Icons.history, 'title': 'history'.tr},
    {
      'icon': Icons.notifications_none_outlined,
      'title': 'notification_settings'.tr
    },
  ];

  //Home Tab
  final selectedActionButtonPagerPosition = 0.obs;
  final dashboardActionButtonsController = PageController(
    initialPage: 0,
  );

  @override
  void onInit() {
    super.onInit();
    isMainViewVisible.value = true;
    pageController = PageController(initialPage: selectedIndex.value);
    setTitle(selectedIndex.value);
  }

  void setTitle(int index) {
    if (index == 0) {
      title.value = 'dashboard'.tr;
    } else if (index == 1) {
      title.value = 'more'.tr;
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int index) {
    selectedIndex.value = index;
    print("selectedIndex.value:${selectedIndex.value}");
    setTitle(index);
  }

  void onItemTapped(int index) {
    // if (index == 1) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => ScannerScreen()),
    //   );
    // } else {
    pageController.jumpToPage(index);

    // }
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {}
  }
}
