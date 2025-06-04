import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/permission_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/user_permissions_response.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/controller/company_permissions_repository.dart';
import 'package:otm_inventory/pages/permissions/user_permissions/model/save_user_permission_request.dart';
import 'package:otm_inventory/pages/permissions/widgets/controller/widgets_repository.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class WidgetsController extends GetxController {
  final _api = WidgetsRepository();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isClearVisible = false.obs,
      isDataUpdated = false.obs;
  final searchController = TextEditingController().obs;
  final companyPermissionList = <PermissionInfo>[].obs;
  List<PermissionInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    getCompanyPermissionsApi(true);
  }

  void getCompanyPermissionsApi(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.getCompanyPermissions(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          UserPermissionsResponse response = UserPermissionsResponse.fromJson(
              jsonDecode(responseModel.result!));
          tempList.clear();
          tempList.addAll(response.permissions ?? []);
          companyPermissionList.value = tempList;
          companyPermissionList.refresh();
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
    companyPermissionList.value = results;
  }

  List<SaveUserPermissionRequest> getRequestData() {
    List<SaveUserPermissionRequest> list = [];
    if (companyPermissionList.isNotEmpty) {
      for (var info in companyPermissionList) {
        list.add(SaveUserPermissionRequest(
            permissionId: info.permissionId,
            status: (info.status ?? false) ? 1 : 0));
      }
    }
    return list;
  }

  Future<void> moveToScreen(String appRout, dynamic arguments) async {
    var result = await Get.toNamed(appRout, arguments: arguments);
    if (result != null && result == true) {
      isDataUpdated.value = true;
      getCompanyPermissionsApi(false);
    }
  }

  void onBackPress() {
    if (isDataUpdated.value) {
      Get.back(result: true);
    } else {
      Get.back();
    }
  }
}
