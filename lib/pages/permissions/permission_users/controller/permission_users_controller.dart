import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/permissions/permission_users/controller/permission_users_repository.dart';
import 'package:belcka/pages/permissions/permission_users/model/permission_user_info.dart';
import 'package:belcka/pages/permissions/permission_users/model/permission_users_response.dart';
import 'package:belcka/pages/permissions/permission_users/model/save_permission_user_request.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';

class PermissionUsersController extends GetxController {
  final _api = PermissionUsersRepository();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isClearVisible = false.obs,
      isDataUpdated = false.obs,
      isHandlingPop = false.obs,
      isCheckAll = false.obs;
  final searchController = TextEditingController().obs;
  final permissionUsersList = <PermissionUserInfo>[].obs;
  List<PermissionUserInfo> tempList = [];
  int permissionId = 0;
  RxString title = "".obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      permissionId = arguments[AppConstants.intentKey.permissionId] ?? 0;
      title.value = arguments[AppConstants.intentKey.title] ?? "";
    }
    getPermissionUsersApi();
  }

  void getPermissionUsersApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["permission_id"] = permissionId;
    _api.getPermissionUsers(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          PermissionUsersResponse response = PermissionUsersResponse.fromJson(
              jsonDecode(responseModel.result!));
          tempList.clear();
          tempList.addAll(response.info ?? []);
          permissionUsersList.value = tempList;
          permissionUsersList.refresh();
          checkSelectAll();
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

  Future<bool> changePermissionUserStatusApi() async {
    bool isLoadedApi = false;
    Map<String, dynamic> map = {};
    map["permission_id"] = permissionId;
    map["company_id"] = ApiConstants.companyId;
    map["users"] = getRequestData();
    print("users data:" + jsonEncode(getRequestData()));
    isLoading.value = true;
    _api.changePermissionUserStatus(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          AppConstants.isUpdatedPermission = true;
          Get.back(result: true);
          // BaseResponse response =
          //     BaseResponse.fromJson(jsonDecode(responseModel.result!));
          // AppUtils.showApiResponseMessage(response.Message ?? "");
        } else {
          // AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
        isLoadedApi = true;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showApiResponseMessage('no_internet'.tr);
        }
        isLoadedApi = true;
      },
    );

    return isLoadedApi;
  }

  Future<void> searchItem(String value) async {
    print(value);
    List<PermissionUserInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) => (!StringHelper.isEmptyString(element.userName) &&
              element.userName!.toLowerCase().contains(value.toLowerCase())))
          .toList();
    }
    permissionUsersList.value = results;
  }

  List<SavePermissionUserRequest> getRequestData() {
    List<SavePermissionUserRequest> list = [];
    if (permissionUsersList.isNotEmpty) {
      for (var info in permissionUsersList) {
        list.add(SavePermissionUserRequest(
            userId: info.userId, status: (info.status ?? false) ? 1 : 0));
      }
    }
    return list;
  }

  void checkSelectAll() {
    bool isAllSelected = true;
    for (var info in permissionUsersList) {
      if ((info.status ?? false) == false) {
        isAllSelected = false;
        break;
      }
    }
    isCheckAll.value = isAllSelected;
  }

  void checkAll() {
    isDataUpdated.value = true;
    isCheckAll.value = true;
    for (var info in permissionUsersList) {
      info.status = true;
    }
    permissionUsersList.refresh();
  }

  void unCheckAll() {
    isDataUpdated.value = true;
    isCheckAll.value = false;
    for (var info in permissionUsersList) {
      info.status = false;
    }
    permissionUsersList.refresh();
  }

  void onBackPress() {
    if (isDataUpdated.value) {
      changePermissionUserStatusApi();
    } else {
      Get.back();
    }
  }
}
