import 'dart:async';
import 'dart:convert';
import 'package:belcka/pages/profile/my_profile_details/model/my_profile_info_response.dart';
import 'package:belcka/pages/profile/other_user_account/controller/other_user_account_repository.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/dashboard/tabs/more_tab/view/more_tab.dart';
import '../../../dashboard/tabs/home_tab2/view/home_tab.dart';

class OtherUserAccountController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _api = OtherUserAccountRepository();
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
    {'icon': Icons.request_page_outlined, 'title': "requests".tr},
    {'icon': Icons.insert_drive_file_outlined, 'title': 'documents'.tr},
    {'icon': Icons.beach_access_outlined, 'title': 'leaves'.tr},
    {'icon': Icons.badge_outlined, 'title': 'digital_id'.tr},
    {'icon': Icons.home_outlined, 'title': 'rent'.tr},
    {'icon': Icons.history, 'title': 'history'.tr},
  ];

  //Home Tab
  final selectedActionButtonPagerPosition = 0.obs;
  final dashboardActionButtonsController = PageController(
    initialPage: 0,
  );
  final myProfileInfo = MyProfileInfo().obs;
  int? userId = 0;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: selectedIndex.value);
    setTitle(selectedIndex.value);

    var arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments["user_id"] ?? 0;
      getProfileAPI();
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
    pageController.jumpToPage(index);
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
          myProfileInfo.value = response.info!;
          isMainViewVisible.value = true;
        }
        else{
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
