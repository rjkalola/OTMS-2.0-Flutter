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
import 'package:otm_inventory/pages/project/address_list/controller/address_list_repository.dart';
import 'package:otm_inventory/pages/project/address_list/model/address_info.dart';
import 'package:otm_inventory/pages/project/address_list/model/address_list_response.dart';
import 'package:otm_inventory/pages/project/project_info/model/project_info.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/user_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class AddressListController extends GetxController implements MenuItemListener, DialogButtonClickListener{
  final formKey = GlobalKey<FormState>();
  final _api = AddressListRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isClearVisible = false.obs,
      isDataUpdated = false.obs;

  final addressList = <AddressInfo>[].obs;
  List<AddressInfo> tempList = [];
  ProjectInfo? projectInfo;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      projectInfo = arguments[AppConstants.intentKey.projectInfo];
    }
    getAddressListApi();
  }

  void getAddressListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["project_id"] = projectInfo?.id ?? 0;

    _api.getAddressList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          AddressListResponse response =
          AddressListResponse.fromJson(jsonDecode(responseModel.result!));
          tempList.clear();
          tempList.addAll(response.info ?? []);
          addressList.value = tempList;
          addressList.refresh();
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
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated.value = true;
      getAddressListApi();
    }
  }
  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    listItems.add(ModuleInfo(name: 'Add'.tr, action: AppConstants.action.add));
    listItems.add(ModuleInfo(
        name: 'archived_address'.tr,
        action: AppConstants.action.archivedAddress));
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }
  void onBackPress() {
    Get.back(result: isDataUpdated.value);
  }
  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    // TODO: implement onNegativeButtonClicked
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {
    // TODO: implement onOtherButtonClicked
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    // TODO: implement onPositiveButtonClicked
  }

  @override
  void onSelectMenuItem(ModuleInfo info, String dialogType) {
    // TODO: implement onSelectMenuItem
    if (info.action == AppConstants.action.add) {
      var arguments = {
        AppConstants.intentKey.projectInfo: projectInfo,
      };
      moveToScreen(AppRoutes.addAddressScreen, arguments);
    }
    else if (info.action == AppConstants.action.archivedAddress) {
      var arguments = {
        AppConstants.intentKey.projectId: projectInfo?.id ?? 0,
      };
      moveToScreen(AppRoutes.archiveAddressListScreen, arguments);
    }
  }
}
