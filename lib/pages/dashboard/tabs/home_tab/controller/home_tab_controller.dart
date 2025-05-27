import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/dashboard/controller/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/models/dashboard_response.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_repository.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/local_permission_sequence_change_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/permission_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/user_permissions_response.dart';
import 'package:otm_inventory/pages/dashboard/view/dialogs/control_panel_menu_dialog.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/user_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class HomeTabController extends GetxController implements SelectItemListener {
  final _api = HomeTabRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;

  // RxString nextUpdateLocationTime = "".obs;

  // final listGridItems = DataUtils.getDashboardGridItemsList().obs;
  final dashboardController = Get.put(DashboardController());
  final dashboardResponse = DashboardResponse().obs;
  final listPermissions = <PermissionInfo>[].obs;
  UserInfo? userInfo;

  @override
  void onInit() {
    super.onInit();
    userInfo = Get.find<AppStorage>().getUserInfo();
    setInitialData();
  }

  Future<void> setInitialData() async {
    UserPermissionsResponse? response =
        Get.find<AppStorage>().getUserPermissionsResponse();
    if (response != null &&
        response.permissions != null &&
        response.permissions!.isNotEmpty) {
      UserPermissionsResponse response =
          Get.find<AppStorage>().getUserPermissionsResponse()!;
      listPermissions.clear();
      listPermissions.addAll(response.permissions ?? []);
      isMainViewVisible.value = true;

      bool isInternet = await AppUtils.interNetCheck();
      if (isInternet) {
        List<LocalPermissionSequenceChangeInfo> localSequenceData =
            getLocalSequenceChangedData();
        if (localSequenceData.isNotEmpty) {
          changeDashboardUserPermissionMultipleSequenceApi(
              isProgress: false,
              isLoadPermissionList: true,
              isChangeSequence: false,
              data: localSequenceData);
        } else {
          getDashboardUserPermissionsApi(false);
        }
      }

      print("listPermissions length:" + listPermissions.length.toString());
    } else {
      List<LocalPermissionSequenceChangeInfo> localSequenceData =
          getLocalSequenceChangedData();
      if (localSequenceData.isNotEmpty) {
        changeDashboardUserPermissionMultipleSequenceApi(
            isProgress: true,
            isLoadPermissionList: true,
            isChangeSequence: false,
            data: localSequenceData);
      } else {
        getDashboardUserPermissionsApi(true);
      }
    }
  }

  void onActionButtonClick(String action) {
    if (action == AppConstants.action.clockIn) {
      Get.toNamed(AppRoutes.clockInScreen);
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

  void getDashboardUserPermissionsApi(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["user_id"] = UserUtils.getLoginUserId();
    map["company_id"] = ApiConstants.companyId;
    _api.getDashboardUserPermissionsApi(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          UserPermissionsResponse response = UserPermissionsResponse.fromJson(
              jsonDecode(responseModel.result!));
          AppStorage().setUserPermissionsResponse(response);
          listPermissions.clear();
          listPermissions.addAll(response.permissions ?? []);
        } else {
          // AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          print("isInternetNotAvailable.value:" +
              isInternetNotAvailable.value.toString());
          // AppUtils.showApiResponseMessage('no_internet'.tr);
        }
        // else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  void changeDashboardUserPermissionSequenceApi(
      bool isProgress, int permissionId, int newPosition) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["user_id"] = UserUtils.getLoginUserId();
    map["company_id"] = ApiConstants.companyId;
    map["permission_id"] = permissionId;
    map["new_position"] = newPosition;

    _api.changeDashboardUserPermissionSequenceApi(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
        } else {
          // AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          print("isInternetNotAvailable.value:" +
              isInternetNotAvailable.value.toString());
          // AppUtils.showApiResponseMessage('no_internet'.tr);
        }
        // else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  void changeDashboardUserPermissionMultipleSequenceApi(
      {required bool isProgress,
      bool? isLoadPermissionList,
      bool? isChangeSequence,
      int? permissionId,
      int? newPosition,
      List<LocalPermissionSequenceChangeInfo>? data}) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["user_id"] = UserUtils.getLoginUserId();
    map["company_id"] = ApiConstants.companyId;

    List<LocalPermissionSequenceChangeInfo> list = [];
    if (Get.find<AppStorage>().getLocalSequenceChangeData().isNotEmpty) {
      list.addAll(Get.find<AppStorage>().getLocalSequenceChangeData());
    }

    map["sequence"] = jsonEncode(list);
    // map["sequence"] = list;

    _api.changeDashboardUserPermissionMultipleSequenceApi(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          if (isChangeSequence ?? false) {
            changeDashboardUserPermissionSequenceApi(
                isProgress, permissionId ?? 0, newPosition ?? 0);
          } else if (isLoadPermissionList ?? false) {
            getDashboardUserPermissionsApi(isProgress);
          }
          Get.find<AppStorage>().clearLocalSequenceChangeData();
        } else {
          // AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          print("isInternetNotAvailable.value:" +
              isInternetNotAvailable.value.toString());
          // AppUtils.showApiResponseMessage('no_internet'.tr);
        }
        // else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  Future<void> onReorderPermission(int oldIndex, int newIndex) async {
    print("Item moved to " + oldIndex.toString());
    print("Item moved to " + newIndex.toString());
    final list = listPermissions;
    final movedItem = list.removeAt(oldIndex);
    list.insert(newIndex, movedItem);

    print("-----------11111----------");
    for (var info in list) {
      print(info.sequence.toString());
    }

    for (int i = 0; i < list.length; i++) {
      list[i].sequence = i + 1;
    }

    listPermissions.value = List.from(list);

    // print("listPermissions.value length:"+listPermissions.value.length.toString());

    if (Get.find<AppStorage>().getUserPermissionsResponse() != null) {
      // print("1111");
      UserPermissionsResponse response =
          Get.find<AppStorage>().getUserPermissionsResponse()!;
      response.permissions = list;
      Get.find<AppStorage>().setUserPermissionsResponse(response);
      // print("222");
      UserPermissionsResponse response2 =
          Get.find<AppStorage>().getUserPermissionsResponse()!;
      print("-----------22222333----------");
      for (var info in response2.permissions!) {
        print(info.sequence.toString());
      }

      bool isInternet = await AppUtils.interNetCheck();
      int permissionId = list[newIndex].permissionId!;
      int newPosition = newIndex + 1;
      if (isInternet) {
        if (isLocalSequenceChangeDataAvailable()) {
          changeDashboardUserPermissionMultipleSequenceApi(
              isProgress: false,
              isLoadPermissionList: false,
              isChangeSequence: true,
              permissionId: permissionId,
              newPosition: newPosition);
        } else {
          changeDashboardUserPermissionSequenceApi(
              false, permissionId, newPosition);
        }
      } else {
        addLocalSequenceChangeData(permissionId, newPosition);
      }
    }
  }

  void addLocalSequenceChangeData(int permissionId, int newPosition) {
    List<LocalPermissionSequenceChangeInfo> list = [];
    if (Get.find<AppStorage>().getLocalSequenceChangeData().isNotEmpty) {
      list.addAll(Get.find<AppStorage>().getLocalSequenceChangeData());
    }
    LocalPermissionSequenceChangeInfo info =
        LocalPermissionSequenceChangeInfo();
    info.permissionId = permissionId;
    info.newPosition = newPosition;
    list.add(info);
    print("before length:" +
        Get.find<AppStorage>().getLocalSequenceChangeData().length.toString());
    Get.find<AppStorage>().setLocalSequenceChangeData(list);
    print("after length:" +
        Get.find<AppStorage>().getLocalSequenceChangeData().length.toString());

    print("DATA:" + jsonEncode(list));
  }

  bool isLocalSequenceChangeDataAvailable() {
    return Get.find<AppStorage>().getLocalSequenceChangeData().isNotEmpty;
  }

  List<LocalPermissionSequenceChangeInfo> getLocalSequenceChangedData() {
    List<LocalPermissionSequenceChangeInfo> list = [];
    UserPermissionsResponse? response =
        Get.find<AppStorage>().getUserPermissionsResponse();
    if (response != null &&
        response.permissions != null &&
        response.permissions!.isNotEmpty) {
      for (var info in response.permissions!) {
        if (info.isSequenceChanged ?? false) {
          LocalPermissionSequenceChangeInfo data =
              LocalPermissionSequenceChangeInfo(
                  permissionId: info.permissionId, newPosition: info.sequence);
          list.add(data);
        }
      }
    }
    return list;
  }

  onClickPermission(int index, PermissionInfo info) {
    showControlPanelDialog();
  }

  void showControlPanelDialog() {
    Get.bottomSheet(
        ControlPanelMenuDialog(
          dialogType: AppConstants.dialogIdentifier.controlPanelMenuDialog,
          list: DataUtils.getControlPanelMenuItems(),
          listener: this,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.action.companyDetails) {}
  }
}
