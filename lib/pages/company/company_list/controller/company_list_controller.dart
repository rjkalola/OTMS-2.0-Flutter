import 'dart:convert';

import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/company/company_list/controller/company_list_repository.dart';
import 'package:belcka/pages/company/company_list/model/company_list_response.dart';
import 'package:belcka/pages/company/company_signup/model/company_info.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';

import '../../../../utils/app_constants.dart';

class CompanyListController extends GetxController
    implements MenuItemListener, DialogButtonClickListener {
  final _api = CompanyListRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isClearVisible = false.obs,
      isDataUpdated = false.obs,
      isDeleteEnable = false.obs;
  final searchController = TextEditingController().obs;
  final companyList = <CompanyInfo>[].obs;
  int selectedCompanyId = 0;
  List<CompanyInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments;
    // if (arguments != null) {
    //   permissionId = arguments[AppConstants.intentKey.permissionId] ?? 0;
    // }
    getCompanyListApi();
  }

  void getCompanyListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["user_id"] = UserUtils.getLoginUserId();
    _api.getCompanyList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          CompanyListResponse response =
              CompanyListResponse.fromJson(jsonDecode(responseModel.result!));
          tempList.clear();
          tempList.addAll(response.info ?? []);
          companyList.value = tempList;
          companyList.refresh();
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

  void deleteCompanyApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = selectedCompanyId;
    _api.deleteCompany(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
          if (selectedCompanyId == ApiConstants.companyId) {
            ApiConstants.companyId = 0;
            Get.find<AppStorage>().setCompanyId(ApiConstants.companyId);
          }
          getCompanyListApi();
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

  Future<void> searchItem(String value) async {
    print(value);
    List<CompanyInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) => (!StringHelper.isEmptyString(element.name) &&
              element.name!.toLowerCase().contains(value.toLowerCase())))
          .toList();
    }
    companyList.value = results;
  }

  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    listItems.add(ModuleInfo(
        name: 'create_or_join'.tr, action: AppConstants.action.addOrJoin));
    // listItems
    //     .add(ModuleInfo(name: 'delete'.tr, action: AppConstants.action.delete));
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  @override
  Future<void> onSelectMenuItem(ModuleInfo info, String dialogType) async {
    if (info.action == AppConstants.action.addOrJoin) {
      moveToScreen(AppRoutes.joinCompanyScreen, null);
    } else if (info.action == AppConstants.action.delete) {
      searchController.value.clear();
      searchItem("");
      isClearVisible.value = false;
      isDeleteEnable.value = true;
    }
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated.value = true;
      getCompanyListApi();
    }
  }

  showDeleteTeamDialog(int companyId) async {
    selectedCompanyId = companyId;
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
      Get.back();
      deleteCompanyApi();
    }
  }
}
