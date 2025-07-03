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

class MyAccountController extends GetxController with GetSingleTickerProviderStateMixin{

  final _api = MyAccountRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs, isMainViewVisible = false.obs;

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
    {'icon': Icons.receipt, 'title': 'Billing'},
    {'icon': Icons.health_and_safety_outlined, 'title': 'Health Info'},
    {'icon': Icons.favorite_border, 'title': 'Health & Safety'},
    {'icon': Icons.request_page_outlined, 'title': 'My Requests'},
    {'icon': Icons.insert_drive_file_outlined, 'title': 'Documents'},
    {'icon': Icons.beach_access_outlined, 'title': 'My Leaves'},
    {'icon': Icons.badge_outlined, 'title': 'Digital ID'},
    {'icon': Icons.home_outlined, 'title': 'Rent'},
    {'icon': Icons.history, 'title': 'History'},
  ];

  @override
  void onInit() {
    super.onInit();
    isMainViewVisible.value = true;
  }
  void onPageChanged(int index) {
    selectedIndex.value = index;
    print("selectedIndex.value:${selectedIndex.value}");
    //setTitle(index);
  }
  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {

    }
  }
}