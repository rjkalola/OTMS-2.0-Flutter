import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/listener/DialogButtonClickListener.dart';
import 'package:otm_inventory/pages/company/company_signup/model/company_info.dart';
import 'package:otm_inventory/pages/company/switch_company/controller/switch_company_repository.dart';
import 'package:otm_inventory/pages/company/switch_company/model/company_list_response.dart';
import 'package:otm_inventory/utils/AlertDialogHelper.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/utils/user_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class SwitchCompanyController extends GetxController
    implements DialogButtonClickListener {
  final _api = SwitchCompanyRepository();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isClearVisible = false.obs,
      isDataUpdated = false.obs;
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
    getSwitchCompanyListApi();
  }

  void getSwitchCompanyListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["user_id"] = UserUtils.getLoginUserId();
    _api.getSwitchCompanyList(
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

  void switchCompanyApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["user_id"] = UserUtils.getLoginUserId();
    map["company_id"] = selectedCompanyId;
    _api.switchCompany(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showSnackBarMessage(response.Message ?? "");
          Get.find<AppStorage>().setCompanyId(selectedCompanyId);
          ApiConstants.companyId = selectedCompanyId;
          Get.back(result: true);
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

  showSwitchCompanyDialog(int companyId) async {
    selectedCompanyId = companyId;
    AlertDialogHelper.showAlertDialog(
        "",
        'are_you_sure_you_want_to_switch'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        false,
        false,
        this,
        AppConstants.dialogIdentifier.joinCompany);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
    for (var info in companyList) {
      info.isActiveCompany = false;
    }
    companyList.refresh();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.joinCompany) {
      Get.back();
      switchCompanyApi();
    }
  }
}
