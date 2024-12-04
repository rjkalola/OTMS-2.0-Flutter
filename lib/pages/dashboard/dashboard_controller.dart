import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_repository.dart';
import 'package:otm_inventory/pages/dashboard/models/dashboard_stock_count_response.dart';
import 'package:otm_inventory/pages/dashboard/models/permission_response.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/home_tab.dart';
import 'package:otm_inventory/pages/dashboard/tabs/more_tab/more_tab.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../utils/app_constants.dart';
import '../../utils/app_storage.dart';
import '../../utils/app_utils.dart';
import '../../utils/data_utils.dart';
import '../../web_services/api_constants.dart';
import '../../web_services/response/module_info.dart';
import '../../web_services/response/response_model.dart';
import '../common/drop_down_tile_list_dialog.dart';
import '../common/listener/select_item_listener.dart';
import '../stock_filter/controller/stock_filter_repository.dart';
import '../stock_filter/model/stock_filter_response.dart';
import 'models/DashboardActionItemInfo.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin
    implements SelectItemListener {
  final _api = DashboardRepository();
  var storeList = <ModuleInfo>[].obs;
  final storeNameController = TextEditingController().obs;
  final List<List<DashboardActionItemInfo>> listHeaderButtons_ =
      DataUtils.generateChunks(DataUtils.getHeaderActionButtonsList(), 3).obs;
  final List<DashboardActionItemInfo> listHeaderButtons =
      DataUtils.getHeaderActionButtonsList().obs;
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final title = 'dashboard'.tr.obs,
      downloadTitle = 'download'.tr.obs,
      allTotalAmount = "".obs,
      inStockAmount = "".obs,
      lowStockAmount = "".obs,
      outOfStockAmount = "".obs,
      minusStockAmount = "".obs,
      finishingAmount = "".obs,
      currencySymbol = "".obs;

  final selectedIndex = 0.obs,
      mAllStockCount = 0.obs,
      mInStockCount = 0.obs,
      mLowStockCount = 0.obs,
      mOutOfStockCount = 0.obs,
      mMinusStockCount = 0.obs,
      mFinishingProductsCount = 0.obs,
      mCancelledCount = 0.obs,
      mIssuedCount = 0.obs,
      mReceivedCount = 0.obs,
      mPartiallyReceivedCount = 0.obs;

  double downloadRate = 0;
  double uploadRate = 0;

  bool readyToTest = false;
  bool loadingDownload = false;
  bool loadingUpload = false;

  // final pageController = PageController();
  late final PageController pageController;
  final tabs = <Widget>[
    // StockListScreen(),
    HomeTab(),
    // ProfileTab(),
    MoreTab(),
  ];

  @override
  Future<void> onInit() async {
    super.onInit();
    // checkInternetSpeed();
    var arguments = Get.arguments;
    if (arguments != null) {
      selectedIndex.value = arguments[AppConstants.intentKey.dashboardTabIndex];
    }
    pageController = PageController(initialPage: selectedIndex.value);
    setTitle(selectedIndex.value);

    AppStorage.storeId = Get.find<AppStorage>().getStoreId();
    AppStorage.storeName = Get.find<AppStorage>().getStoreName();
    if (!StringHelper.isEmptyString(AppStorage.storeName)) {
      storeNameController.value.text = AppStorage.storeName;
      setDashboardData();
    }

    getSettingApi();
  }

  Future<void> setDashboardData() async {
    bool isInternet = await AppUtils.interNetCheck();
    print("isInternet:" + isInternet.toString());
    if (isInternet) {
      getDashboardStockCountApi(true);
    } else {
      isMainViewVisible.value = true;
      if (AppStorage().getDashboardStockCountData() != null) {
        DashboardStockCountResponse response =
            AppStorage().getDashboardStockCountData()!;
        setItemCount(response);
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

  void selectStore() {
    if (storeList.isNotEmpty) {
      showStoreListDialog(AppConstants.dialogIdentifier.storeList,
          'select_the_store'.tr, storeList, true, true, true, true, this);
    } else {
      AppUtils.showSnackBarMessage('empty_store_message'.tr);
    }
  }

  void showStoreListDialog(
      String dialogType,
      String title,
      List<ModuleInfo> list,
      bool enableDrag,
      bool isDismiss,
      bool canPop,
      bool isClose,
      SelectItemListener listener) {
    Get.bottomSheet(
        enableDrag: enableDrag,
        isDismissible: isDismiss,
        PopScope(
          canPop: canPop,
          child: DropDownTileListDialog(
            title: title,
            dialogType: dialogType,
            list: list,
            listener: listener,
            isCloseEnable: isClose,
            isSearchEnable: false,
          ),
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.storeList) {
      AppStorage.storeId = id;
      AppStorage.storeName = name;
      storeNameController.value.text = name;
      Get.find<AppStorage>().setStoreId(id);
      Get.find<AppStorage>().setStoreName(name);
      setHeaderListArray();
      setDashboardData();
    }
  }

  Future<void> onClickStockItem(int stockCountType) async {
    String title = 'stocks'.tr;
    int count = 0;
    if (stockCountType == 1) {
      title = 'in_stock'.tr;
      // count = (mInStockCount.value + mLowStockCount.value);
      count = mInStockCount.value;
    } else if (stockCountType == 2) {
      title = 'low_stock'.tr;
      count = mLowStockCount.value;
    } else if (stockCountType == 3) {
      title = 'out_of_stock'.tr;
      count = mOutOfStockCount.value;
    } else if (stockCountType == 4) {
      title = 'minus_stock'.tr;
      count = mMinusStockCount.value;
    } else if (stockCountType == 5) {
      title = 'finishing_products'.tr;
      count = mFinishingProductsCount.value;
    }
    var arguments = {
      AppConstants.intentKey.stockCountType: stockCountType,
      AppConstants.intentKey.title: title,
      AppConstants.intentKey.count: count
    };
    Get.offNamed(AppRoutes.stockListScreen, arguments: arguments);
  }

  Future<void> onClickInStockItem() async {
    var arguments = {
      AppConstants.intentKey.allStockType: true,
      AppConstants.intentKey.title: 'in_stock'.tr,
      AppConstants.intentKey.count: (mInStockCount.value + mLowStockCount.value)
    };
    Get.offNamed(AppRoutes.stockListScreen, arguments: arguments);
  }

  Future<void> onClickAllStockItem() async {
    var arguments = {
      AppConstants.intentKey.allStockType: true,
      AppConstants.intentKey.title: 'stocks'.tr,
      AppConstants.intentKey.count: mAllStockCount.value
    };
    Get.offNamed(AppRoutes.stockListScreen, arguments: arguments);
  }

  void getDashboardStockCountApi(bool isProgress) async {
    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();
    multi.FormData formData = multi.FormData.fromMap(map);
    isLoading.value = isProgress;
    _api.getDashboardStockCountResponse(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          DashboardStockCountResponse response =
              DashboardStockCountResponse.fromJson(
                  jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            isMainViewVisible.value = true;
            AppStorage().setDashboardStockCountData(response);
            setItemCount(response);
          } else {
            AppUtils.showSnackBarMessage(response.message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isMainViewVisible.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  void setItemCount(DashboardStockCountResponse? response) {
    if (response != null) {
      mInStockCount.value = response.inStockCount ?? 0;
      mLowStockCount.value = response.lowStockCount ?? 0;
      mOutOfStockCount.value = response.outOfStockCount ?? 0;
      mMinusStockCount.value = response.minusStockCount ?? 0;
      mFinishingProductsCount.value = response.finishing_products ?? 0;
      mIssuedCount.value = response.issuedCount ?? 0;
      mReceivedCount.value = response.receivedCount ?? 0;
      mPartiallyReceivedCount.value = response.partiallyReceived ?? 0;
      mCancelledCount.value = response.cancelledCount ?? 0;

      currencySymbol.value = response.currency_symbol ?? "";
      allTotalAmount.value = "${currencySymbol.value}${response.all_total_amount ?? ""}";
      inStockAmount.value = "${currencySymbol.value}${response.in_stock_count_total_amount ?? ""}";
      lowStockAmount.value = "${currencySymbol.value}${response.low_stock_count_total_amount ?? ""}";
      outOfStockAmount.value = "${currencySymbol.value}${response.out_of_stock_count_total_amount ?? ""}";
      minusStockAmount.value = "${currencySymbol.value}${response.minus_stock_count_total_amount ?? ""}";
      finishingAmount.value = "${currencySymbol.value}${response.finishing_products_total_amount ?? ""}";

      if (!StringHelper.isEmptyString(response.data_size)) {
        downloadTitle.value = "${'download'.tr} (${response.data_size!})";
      } else {
        downloadTitle.value = 'download'.tr;
      }
    }
  }

  void getFiltersListApi() async {
    Map<String, dynamic> map = {};
    multi.FormData formData = multi.FormData.fromMap(map);
    // isLoading.value = true;
    StockFilterRepository().getStockFiltersList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          StockFilterResponse response =
              StockFilterResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
          } else {
            AppUtils.showSnackBarMessage(response.message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isMainViewVisible.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  void setHeaderListArray() {
    listHeaderButtons_.clear();
    listHeaderButtons_.addAll(
        DataUtils.generateChunks(DataUtils.getHeaderActionButtonsList(), 3)
            .obs);
    listHeaderButtons.clear();
    listHeaderButtons.addAll(DataUtils.getHeaderActionButtonsList());
  }

  void logoutAPI() async {
    String deviceModelName = await AppUtils.getDeviceName();
    Map<String, dynamic> map = {};
    map["model_name"] = deviceModelName;
    map["is_inventory"] = "true";
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
    _api.getSettingsAPI(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          PermissionResponse response =
              PermissionResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            AppStorage().setPermissions(response);
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

}
