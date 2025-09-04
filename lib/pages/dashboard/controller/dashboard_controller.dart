import 'dart:convert';

import 'package:belcka/utils/user_utils.dart';
import 'package:dio/dio.dart' as multi;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/dashboard/controller/dashboard_repository.dart';
import 'package:belcka/pages/dashboard/models/dashboard_response.dart';
import 'package:belcka/pages/dashboard/models/dashboard_stock_count_response.dart';
import 'package:belcka/pages/dashboard/models/permission_settings.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/view/home_tab.dart';
import 'package:belcka/pages/dashboard/tabs/more_tab/more_tab.dart';
import 'package:belcka/routes/app_routes.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/app_storage.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/string_helper.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/base_response.dart';
import '../../../web_services/response/response_model.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _api = DashboardRepository();

  // final List<List<DashboardActionItemInfo>> listHeaderButtons_ =
  //     DataUtils.generateChunks(DataUtils.getHeaderActionButtonsList(), 3).obs;
  // final List<DashboardActionItemInfo> listHeaderButtons =
  //     DataUtils.getHeaderActionButtonsList().obs;
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final title = 'dashboard'.tr.obs;
  final selectedIndex = 0.obs;

  // final pageController = PageController();
  late final PageController pageController;
  final tabs = <Widget>[
    // StockListScreen(),
    HomeTab(),
    // ProfileTab(),
    MoreTab(),
    MoreTab(),
    MoreTab(),
  ];

  @override
  Future<void> onInit() async {
    super.onInit();
    // checkInternetSpeed();
    print("dashboard onInit");

    var arguments = Get.arguments;
    if (arguments != null) {
      selectedIndex.value = arguments[AppConstants.intentKey.dashboardTabIndex];
    }
    pageController = PageController(initialPage: selectedIndex.value);
    setTitle(selectedIndex.value);

    // setDashboardData();
    // getSettingApi();
    getFirebaseToken();
  }

  Future<void> getFirebaseToken() async {
    // Get token
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    if (!StringHelper.isEmptyString(token)) {
      registerFcmAPI(token ?? "");
    }
  }

  void registerFcmAPI(String token) async {
    Map<String, dynamic> map = {};
    map["userId"] = UserUtils.getLoginUserId();
    map["token"] = token;
    map["device_type"] = AppConstants.deviceType;
    // multi.FormData formData = multi.FormData.fromMap(map);

    _api.registerFcm(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {

          } else {
            // AppUtils.showSnackBarMessage(response.message!);
          }
        } else {
          // AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        // isLoading.value = false;
      },
      onError: (ResponseModel error) {
        // isLoading.value = false;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   isInternetNotAvailable.value = true;
        //   // Utils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  Future<void> setDashboardData() async {
    bool isInternet = await AppUtils.interNetCheck();
    print("isInternet:" + isInternet.toString());
    if (isInternet) {
    } else {
      isMainViewVisible.value = true;
      if (AppStorage().getDashboardStockCountData() != null) {
        DashboardStockCountResponse response =
            AppStorage().getDashboardStockCountData()!;
      }
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

  void setTitle(int index) {
    if (index == 0) {
      title.value = 'dashboard'.tr;
    }
    // else if (index == 1) {
    //   title.value = 'profile'.tr;
    // }
    else if (index == 1) {
      title.value = 'more'.tr;
    }
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

  //Home Tab
  final selectedActionButtonPagerPosition = 0.obs;
  final dashboardActionButtonsController = PageController(
    initialPage: 0,
  );

  void onActionButtonClick(String action) {
    if (action == AppConstants.action.items) {
      Get.offNamed(AppRoutes.productListScreen);
    } else if (action == AppConstants.action.store) {
      Get.offNamed(AppRoutes.storeListScreen);
    } else if (action == AppConstants.action.stocks) {
      Get.offNamed(AppRoutes.stockListScreen);
    } else if (action == AppConstants.action.suppliers) {
      Get.offNamed(AppRoutes.supplierListScreen);
    } else if (action == AppConstants.action.categories) {
      Get.offNamed(AppRoutes.categoryListScreen);
    }
  }

  void getDashboardApi() {
    _api.getDashboardResponse(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          DashboardResponse response =
              DashboardResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            AppStorage().setDashboardResponse(response);
          } else {
            // AppUtils.showSnackBarMessage(response.message!);
          }
        } else {
          // AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        // isLoading.value = false;
      },
      onError: (ResponseModel error) {
        // isLoading.value = false;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   isInternetNotAvailable.value = true;
        //   // Utils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  void logoutAPI() async {
    String deviceModelName = await AppUtils.getDeviceName();
    Map<String, dynamic> map = {};
    map["model_name"] = deviceModelName;
    // map["is_inventory"] = "true";
    multi.FormData formData = multi.FormData.fromMap(map);
    print("request parameter:" + map.toString());
    isLoading.value = true;
    _api.logout(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          Get.find<AppStorage>().clearAllData();
          Get.offAllNamed(AppRoutes.loginScreen);
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  void getSettingApi() {
    isLoading.value = true;
    _api.getSettingsAPI(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          PermissionSettings response =
              PermissionSettings.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            AppStorage().setPermissions(response);
            // Get.put(HomeTabController()).getDashboardApi(true);
          } else {
            AppUtils.showSnackBarMessage(response.message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        // isLoading.value = false;
      },
      onError: (ResponseModel error) {
        // isLoading.value = false;

        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   isInternetNotAvailable.value = true;
        //   // Utils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }
}
