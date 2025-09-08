import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/dashboard/tabs/more_tab/view/more_tab.dart';
import 'package:belcka/pages/project/address_details/controller/address_details_repository.dart';
import 'package:belcka/pages/project/address_details/model/address_details_info.dart';
import 'package:belcka/pages/project/address_list/model/address_info.dart';
import 'package:belcka/pages/project/project_details/model/project_details_api_response.dart';
import 'package:belcka/pages/project/project_details/model/project_detals_item.dart';
import 'package:belcka/pages/project/update_address_progress/view/update_address_progress_screen.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:path/path.dart';
import '../../../dashboard/tabs/home_tab2/view/home_tab.dart';

class AddressDetailsController extends GetxController
    implements MenuItemListener, DialogButtonClickListener {
  final _api = AddressDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isDataUpdated = false.obs,
      isResetEnable = false.obs;

  final selectedIndex = 0.obs;
  late final PageController pageController;

  final List<ProjectDetalsItem> items = [
    ProjectDetalsItem(
        title: 'check_in_'.tr,
        subtitle: '',
        iconPath: Drawable.clockIcon,
        iconColor: "#000000",
        flagName: "Check-In"),
    ProjectDetalsItem(
        title: 'materials'.tr,
        subtitle: '',
        iconPath: Drawable.poundIcon,
        iconColor: "#000000",
        flagName: "Materials"),
    ProjectDetalsItem(
        title: 'trades'.tr,
        subtitle: '',
        iconPath: Drawable.tradesPermissionIcon,
        iconColor: "#000000",
        flagName: "Trades"),
  ];

  AddressDetailsInfo? addressDetailsInfo;
  AddressInfo? addressInfo;

  final RxInt selectedDateFilterIndex = (0).obs;
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
              AddressDetailsInfoResponse.fromJson(
                  jsonDecode(responseModel.result!));
          addressDetailsInfo = response.info;
          if (addressDetailsInfo != null) {
            updateItemsWithApi(addressDetailsInfo!);
          }
        } else {
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
      switch (item.flagName) {
        case 'Check-In':
          item.subtitle = address.checkIns.toString();
          break;
        case 'Trades':
          item.subtitle = address.trades.toString();
          break;
        case 'Materials':
          item.subtitle = "${address.currency}${address.materials.toString()}";
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
    listItems.add(ModuleInfo(
        name: 'archive'.tr, action: AppConstants.action.archiveProject));
    listItems
        .add(ModuleInfo(name: 'delete'.tr, action: AppConstants.action.delete));
    listItems
        .add(ModuleInfo(name: 'edit'.tr, action: AppConstants.action.edit));
    listItems.add(ModuleInfo(
        name: 'change_progress'.tr, action: AppConstants.action.inProgress));
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
    if (info.action == AppConstants.action.archiveProject) {
      archiveAddressApi();
    } else if (info.action == AppConstants.action.delete) {
      showDeleteTeamDialog();
    } else if (info.action == AppConstants.action.edit) {
      var arguments = {
        AppConstants.intentKey.addressDetailsInfo: addressDetailsInfo
      };
      moveToScreen(AppRoutes.addAddressScreen, arguments);
    } else if (info.action == AppConstants.action.inProgress) {
      openBottomSheet(Get.context!);
    }
  }

  void openBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => UpdateAddressProgressScreen(
        addressDetailsInfo: addressDetailsInfo!,
      ),
    );

    if (result == true) {
      isDataUpdated.value = true;
      getAddressDetailsApi();
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
