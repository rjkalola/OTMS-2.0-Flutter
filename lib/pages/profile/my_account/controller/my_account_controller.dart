import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/dashboard/tabs/more_tab/view/more_tab.dart';
import 'package:belcka/pages/profile/my_account/controller/my_account_repository.dart';
import 'package:belcka/pages/profile/my_account/model/my_account_menu_item.dart';
import 'package:belcka/pages/profile/my_profile_details/model/my_profile_info_response.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  List<MyAccountMenuItem> menuItems() {
    var arrayItems = <MyAccountMenuItem>[];
    arrayItems.add(MyAccountMenuItem(
        title: 'billing'.tr,
        action: AppConstants.action.billingInfo,
        iconData: Icons.receipt));
    arrayItems.add(MyAccountMenuItem(
      title: 'health_info'.tr,
      iconData: Icons.health_and_safety_outlined,
      action: AppConstants.action.healthInfo,
    ));
    arrayItems.add(MyAccountMenuItem(
        title: 'health_safety'.tr,
        action: AppConstants.action.healthSafety,
        iconData: Icons.favorite_border));
    arrayItems.add(MyAccountMenuItem(
        title: 'my_requests'.tr,
        action: AppConstants.action.myRequests,
        iconData: Icons.request_page_outlined));
    arrayItems.add(MyAccountMenuItem(
        title: 'documents'.tr,
        action: AppConstants.action.documents,
        iconData: Icons.insert_drive_file_outlined));
    arrayItems.add(MyAccountMenuItem(
        title: 'my_leaves'.tr,
        action: AppConstants.action.myLeaves,
        iconData: Icons.beach_access_outlined));
    arrayItems.add(MyAccountMenuItem(
        title: 'digital_id'.tr,
        action: AppConstants.action.digitalId,
        iconData: Icons.badge_outlined));
    arrayItems.add(MyAccountMenuItem(
        title: 'rent'.tr,
        action: AppConstants.action.rent,
        iconData: Icons.home_outlined));
    arrayItems.add(MyAccountMenuItem(
        title: 'history'.tr,
        action: AppConstants.action.history,
        iconData: Icons.history));
    if (UserUtils.isLoginUser(userId)) {
      arrayItems.add(MyAccountMenuItem(
          title: 'notification_settings'.tr,
          action: AppConstants.action.notificationSettings,
          iconData: Icons.notifications_none_outlined));
    }
    return arrayItems;
  }

  // final List<Map<String, dynamic>> menuItems = [
  //   {'icon': Icons.receipt, 'title': 'billing'.tr},
  //   {'icon': Icons.health_and_safety_outlined, 'title': 'health_info'.tr},
  //   {'icon': Icons.favorite_border, 'title': 'health_safety'.tr},
  //   {'icon': Icons.request_page_outlined, 'title': "my_requests".tr},
  //   {'icon': Icons.insert_drive_file_outlined, 'title': 'documents'.tr},
  //   {'icon': Icons.beach_access_outlined, 'title': 'my_leaves'.tr},
  //   {'icon': Icons.badge_outlined, 'title': 'digital_id'.tr},
  //   {'icon': Icons.home_outlined, 'title': 'rent'.tr},
  //   {'icon': Icons.history, 'title': 'history'.tr},
  //   {
  //     'icon': Icons.notifications_none_outlined,
  //     'title': 'notification_settings'.tr
  //   },
  // ];

  //Home Tab
  final selectedActionButtonPagerPosition = 0.obs;
  final dashboardActionButtonsController = PageController(
    initialPage: 0,
  );
  int? userId = UserUtils.getLoginUserId();
  final userInfo = UserUtils.getUserInfo().obs;

  // final isOtherUserProfile = false.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: selectedIndex.value);
    setTitle(selectedIndex.value);
    var arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ??
          UserUtils.getLoginUserId();
    }
    if (!UserUtils.isLoginUser(userId)) {
      getProfileAPI();
    } else {
      isMainViewVisible.value = true;
    }
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

  void getProfileAPI() async {
    Map<String, dynamic> map = {};
    map["user_id"] = userId;
    map["company_id"] = ApiConstants.companyId;
    isLoading.value = true;
    _api.getProfile(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          MyProfileInfoResponse response =
              MyProfileInfoResponse.fromJson(jsonDecode(responseModel.result!));
          userInfo.value = response.info!;
          isMainViewVisible.value = true;
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }
}
