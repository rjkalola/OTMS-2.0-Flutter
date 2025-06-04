import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/permission_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/user_permissions_response.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/controller/company_permissions_repository.dart';
import 'package:otm_inventory/pages/permissions/search_user/view/search_user_screen.dart';
import 'package:otm_inventory/pages/permissions/user_permissions/controller/user_permissions_repository.dart';
import 'package:otm_inventory/pages/permissions/user_permissions/model/save_user_permission_request.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
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
      isClearVisible = false.obs,
      isDataUpdated = false.obs;
  final searchController = TextEditingController().obs;
  final userPermissionList = <PermissionInfo>[].obs;
  List<PermissionInfo> tempList = [];
  int userId = 0;
  String userName = "";
  final usersList = <UserInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ?? 0;
      userName = arguments[AppConstants.intentKey.userName] ?? "";
      usersList.value = arguments[AppConstants.intentKey.userList] ?? [];
      searchController.value.text = userName;
    }
    getCompanyPermissionsApi();
  }

  void getCompanyPermissionsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["user_id"] = userId;
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

  void changeUserBulkPermissionStatusApi(
      {int? permissionId, bool? status}) async {
    Map<String, dynamic> map = {};
    map["user_id"] = userId;
    map["company_id"] = ApiConstants.companyId;
    // map["permission_id"] = permissionId;
    // map["status"] = status ? 1 : 0;
    map["permissions"] = getRequestData();

    isLoading.value = true;
    _api.changeUserBulkPermissionStatus(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          Get.back(result: true);
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

  List<SaveUserPermissionRequest> getRequestData() {
    List<SaveUserPermissionRequest> list = [];
    if (userPermissionList.isNotEmpty) {
      for (var info in userPermissionList) {
        list.add(SaveUserPermissionRequest(
            permissionId: info.permissionId,
            status: (info.status ?? false) ? 1 : 0));
      }
    }
    return list;
  }

  Future<void> moveToSearchUSer() async {
    var arguments = {
      AppConstants.intentKey.userId: userId,
      AppConstants.intentKey.userName: userName,
      AppConstants.intentKey.userList: usersList,
    };
    // var result =
    //     await Get.toNamed(AppRoutes.searchUserScreen, arguments: arguments);

    var result = await Get.to(
      () => SearchUserScreen(),
      arguments: arguments,
      transition: Transition.downToUp, // ➡ Slide + Fade
      duration: Duration(milliseconds: 300),
    );

    if (result != null) {
      var arguments = result;
      UserInfo info = arguments[AppConstants.intentKey.userInfo];
      if (userId != info.id) {
        userId = info.id ?? 0;
        userName = info.name ?? "";
        searchController.value.text = userName;
        getCompanyPermissionsApi();
      }
    }
  }

  void onBackPress() {
    if (isDataUpdated.value) {
      changeUserBulkPermissionStatusApi();
    } else {
      Get.back();
    }
  }
}
