import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otm_inventory/pages/common/listener/DialogButtonClickListener.dart';
import 'package:otm_inventory/pages/common/listener/menu_item_listener.dart';
import 'package:otm_inventory/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:otm_inventory/pages/dashboard/tabs/more_tab/more_tab.dart';
import 'package:otm_inventory/pages/project/address_details/controller/address_details_repository.dart';
import 'package:otm_inventory/pages/project/address_details/model/address_details_info.dart';
import 'package:otm_inventory/pages/project/address_list/model/address_info.dart';
import 'package:otm_inventory/pages/project/project_details/model/project_details_api_response.dart';
import 'package:otm_inventory/pages/project/project_details/model/project_detals_item.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/AlertDialogHelper.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/user_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';
import '../../../dashboard/tabs/home_tab2/view/home_tab.dart';

class AddressDetailsController extends GetxController
    implements MenuItemListener, DialogButtonClickListener{
  final _api = AddressDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isDataUpdated = false.obs,isResetEnable = false.obs;

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

  final List<ProjectDetalsItem> items = [
    ProjectDetalsItem(title: 'Check-In', subtitle: ''),
    ProjectDetalsItem(title: 'Materials', subtitle: ''),
    ProjectDetalsItem(title: 'Trades', subtitle: ''),
  ];

  AddressDetailsInfo? addressDetailsInfo;
  AddressInfo? addressInfo;

  final RxInt selectedDateFilterIndex = (-1).obs;
  String filterPerDay = "", startDate = "", endDate = "";

  //Home Tab
  final selectedActionButtonPagerPosition = 0.obs;
  final dashboardActionButtonsController = PageController(
    initialPage: 0,
  );

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: selectedIndex.value);
    var arguments = Get.arguments;
    if (arguments != null) {
      addressInfo = arguments[AppConstants.intentKey.addressInfo];
    }
    getAddressDetailsApi();
  }

  void getAddressDetailsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["address_id"] = addressInfo?.id ?? 0;
    map["start_date"] = startDate;
    map["end_date"] = endDate;

    _api.getAddressDetails(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          AddressDetailsInfoResponse response =
          AddressDetailsInfoResponse.fromJson(jsonDecode(responseModel.result!));
          addressDetailsInfo = response.info;
          if (addressDetailsInfo != null) {
            updateItemsWithApi(addressDetailsInfo!);
          }
        }
        else{
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void archiveAddressApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = addressInfo?.id ?? 0;
    _api.archiveAddress(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showApiResponseMessage('no_internet'.tr);
          // Utils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }
  void deleteAddressApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = addressInfo?.id ?? 0;
    _api.deleteAddress(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showApiResponseMessage('no_internet'.tr);
          // Utils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void updateItemsWithApi(AddressDetailsInfo address) {
    for (var item in items) {
      switch (item.title) {
        case 'Check-In':
          item.subtitle = "";
          break;
        case 'Trades':
          item.subtitle = address.trades.toString();
          break;
        case 'Materials':
        item.subtitle = "";
        break;
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
  }

  void onItemTapped(int index) {
    pageController.jumpToPage(index);
  }
  void onBackPress() {
    Get.back(result: isDataUpdated.value);
  }
  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated.value = true;
      //Get.back(result: true);
      getAddressDetailsApi();
    }
  }
  void clearFilter() {
    isResetEnable.value = false;
    filterPerDay = "";
    startDate = "";
    endDate = "";
    selectedDateFilterIndex.value = -1;
    loadAddressDetailsData(true);
  }
  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    listItems
        .add(ModuleInfo(name: 'archive'.tr, action: AppConstants.action.archiveProject));
    listItems
        .add(ModuleInfo(name: 'delete'.tr, action: AppConstants.action.delete));
    listItems
        .add(ModuleInfo(name: 'edit'.tr, action: AppConstants.action.edit));
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }
  Future<void> loadAddressDetailsData(bool isProgress) async {
    getAddressDetailsApi();
  }
  @override
  void onSelectMenuItem(ModuleInfo info, String dialogType) {
    // TODO: implement onSelectMenuItem
    if (info.action == AppConstants.action.archiveProject){
    archiveAddressApi();
    }
    else if (info.action == AppConstants.action.delete) {
      showDeleteTeamDialog();
    }
    else if (info.action == AppConstants.action.edit) {
      var arguments = {
        AppConstants.intentKey.addressDetailsInfo: addressDetailsInfo
      };
      moveToScreen(AppRoutes.addAddressScreen, arguments);
    }
  }

  showDeleteTeamDialog() async {
    AlertDialogHelper.showAlertDialog(
        "",
        'are_you_sure_you_want_to_delete'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.delete);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.delete) {
      deleteAddressApi();
      Get.back();
    }
  }
}