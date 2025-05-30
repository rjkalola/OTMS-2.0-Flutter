import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/permission_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/user_permissions_response.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/controller/company_permissions_repository.dart';
import 'package:otm_inventory/pages/permissions/user_permissions/controller/user_permissions_repository.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/utils/user_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class UserPermissionController extends GetxController {
  final _api = UserPermissionsRepository();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isClearVisible = false.obs;
  final searchController = TextEditingController().obs;
  final userPermissionList = <PermissionInfo>[].obs;
  List<PermissionInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    getCompanyPermissionsApi();
  }

  void getCompanyPermissionsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["user_id"] = UserUtils.getLoginUserId();
    _api.getUserPermissions(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          UserPermissionsResponse response = UserPermissionsResponse.fromJson(
              jsonDecode(responseModel.result!));
          tempList.clear();
          tempList.addAll(response.permissions ?? []);
          userPermissionList.value = tempList;
          userPermissionList.refresh();
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

  void changeCompanyPermissionStatusApi(int permissionId, bool status) async {
    Map<String, dynamic> map = {};
    map["user_id"] = AppUtils.getLoginUserId();
    map["permission_id"] = permissionId;
    map["status"] = status ? 1 : 0;

    // isLoading.value = true;
    _api.changeUserPermissionStatus(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          // BaseResponse response =
          //     BaseResponse.fromJson(jsonDecode(responseModel.result!));
          // AppUtils.showApiResponseMessage(response.Message ?? "");
        } else {
          // AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  Future<void> searchItem(String value) async {
    print(value);
    List<PermissionInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) =>
              (!StringHelper.isEmptyString(element.name) &&
                  element.name!.toLowerCase().contains(value.toLowerCase())) ||
              (!StringHelper.isEmptyString(element.name) &&
                  element.name!.toLowerCase().contains(value.toLowerCase())))
          .toList();
    }
    userPermissionList.value = results;
  }
}
