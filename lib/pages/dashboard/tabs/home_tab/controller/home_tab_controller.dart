import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_repository.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_list_response.dart';
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

class HomeTabController extends GetxController // with WidgetsBindingObserver
    implements
        SelectItemListener {
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
    // WidgetsBinding.instance.addObserver(this);
  }

  // @override
  // void onClose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.onClose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     getDashboardUserPermissionsApi(false);
  //   }
  // }

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
        if (Get.find<AppStorage>().isLocalSequenceChanges()) {
          changeDashboardUserPermissionMultipleSequenceApi(
              isProgress: false,
              isLoadPermissionList: true,
              isChangeSequence: false);
        } else {
          getDashboardUserPermissionsApi(false);
        }
      }
    } else {
      if (Get.find<AppStorage>().isLocalSequenceChanges()) {
        changeDashboardUserPermissionMultipleSequenceApi(
            isProgress: true,
            isLoadPermissionList: true,
            isChangeSequence: false);
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
    map["status"] = 1;

    _api.getDashboardUserPermissionsApi(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          UserPermissionsResponse response = UserPermissionsResponse.fromJson(
              jsonDecode(responseModel.result!));
          response.permissions!.add(DataUtils.getEditWidget());
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
          UserPermissionsResponse? response =
              Get.find<AppStorage>().getUserPermissionsResponse();
          if (response != null && response.permissions != null) {
            UserPermissionsResponse response =
                Get.find<AppStorage>().getUserPermissionsResponse()!;
            listPermissions.clear();
            listPermissions.addAll(response.permissions ?? []);
          } else {
            isInternetNotAvailable.value = true;
          }
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

  /*void changeDashboardUserPermissionSequenceApi(
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
  }*/

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

    // List<LocalPermissionSequenceChangeInfo> list = [];
    // if (Get.find<AppStorage>().getLocalSequenceChangeData().isNotEmpty) {
    //   list.addAll(Get.find<AppStorage>().getLocalSequenceChangeData());
    // }

    map["sequence"] = jsonEncode(getLocalSequenceChangedData());
    // map["sequence"] = list;

    _api.changeDashboardUserPermissionMultipleSequenceApi(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          Get.find<AppStorage>().setLocalSequenceChanges(false);
          /* if (isChangeSequence ?? false) {
            changeDashboardUserPermissionSequenceApi(
                isProgress, permissionId ?? 0, newPosition ?? 0);
          } else */
          if (isLoadPermissionList ?? false) {
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
          /*  isInternetNotAvailable.value = true;
          print("isInternetNotAvailable.value:" +
              isInternetNotAvailable.value.toString());*/
          // AppUtils.showApiResponseMessage('no_internet'.tr);
        }
        // else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  Future<void> getUserWorkLogListApi() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["date"] = "";
    map["shift_id"] = 0;
    ClockInRepository().getUserWorkLogList(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          WorkLogListResponse response =
              WorkLogListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.workLogInfo!.isNotEmpty ||
              (response.userIsWorking ?? false)) {
            moveToScreen(appRout: AppRoutes.clockInScreen);
          } else {
            moveToScreen(appRout: AppRoutes.startShiftMapScreen);
          }
        } else {
          moveToScreen(appRout: AppRoutes.startShiftMapScreen);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  Future<void> onReorderPermission(int oldIndex, int newIndex) async {
    final list = listPermissions;
    final movedItem = list.removeAt(oldIndex);
    list.insert(newIndex, movedItem);

    int updatedPositionCount = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].permissionId != -1) {
        updatedPositionCount = updatedPositionCount + 1;
        list[i].sequence = updatedPositionCount;
      }
    }

    listPermissions.value = List.from(list);

    if (Get.find<AppStorage>().getUserPermissionsResponse() != null) {
      UserPermissionsResponse response =
          Get.find<AppStorage>().getUserPermissionsResponse()!;
      response.permissions = list;
      Get.find<AppStorage>().setUserPermissionsResponse(response);

      bool isInternet = await AppUtils.interNetCheck();
      int permissionId = list[newIndex].permissionId!;
      // int newPosition = newIndex + 1;
      int newPosition = list[newIndex].sequence!;
      if (movedItem.permissionId != -1) {
        Get.find<AppStorage>().setLocalSequenceChanges(true);
        /*if (isInternet) {
          if (Get.find<AppStorage>().isLocalSequenceChanges()) {
            changeDashboardUserPermissionMultipleSequenceApi(
                isProgress: false,
                isLoadPermissionList: false,
                isChangeSequence: false,
                permissionId: permissionId,
                newPosition: newPosition);
          } else {
            changeDashboardUserPermissionSequenceApi(
                false, permissionId, newPosition);
          }
        } else {
          Get.find<AppStorage>().setLocalSequenceChanges(true);
        }*/
      }
    }
  }

  bool isEditWidgetBefore() {
    bool isBefore = false;

    return isBefore;
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
        if ((info.permissionId ?? 0) != -1) {
          list.add(LocalPermissionSequenceChangeInfo(
              permissionId: info.permissionId, newPosition: info.sequence));
        }
      }
    }
    return list;
  }

  onClickPermission(int index, PermissionInfo info) {
    if (info.slug == 'control_panel') {
      showControlPanelDialog();
    } else if (info.slug == 'edit_widget') {
      var arguments = {
        AppConstants.intentKey.userId: UserUtils.getLoginUserId(),
        AppConstants.intentKey.userName: UserUtils.getLoginUserName(),
        AppConstants.intentKey.fromDashboardScreen: true,
      };
      moveToScreen(
          appRout: AppRoutes.userPermissionScreen, arguments: arguments);
    } else if (info.slug == 'teams') {
      Get.toNamed(AppRoutes.teamListScreen);
      // Get.toNamed(AppRoutes.createTeamScreen);
    } else if (info.slug == 'users') {
      Get.toNamed(AppRoutes.userListScreen);
      // Get.toNamed(AppRoutes.createTeamScreen);
    } else if (info.slug == 'shift') {
      getUserWorkLogListApi();
      /* if (UserUtils.isWorking()) {
        Get.toNamed(AppRoutes.clockInScreen);
      } else {
        Get.toNamed(AppRoutes.startShiftMapScreen);
      }*/
    } else if (info.slug == 'settings') {
      moveToScreen(appRout: AppRoutes.settingsScreen);
    } else if (info.slug == 'timesheet') {
      moveToScreen(appRout: AppRoutes.timeSheetListScreen);
    } else if (info.slug == 'bookkeeper') {
      moveToScreen(appRout: AppRoutes.billingDetailsScreen);
    } else if (info.slug == 'my_requests') {
      moveToScreen(appRout: AppRoutes.myRequestsScreen);
    }
  }

  Future<void> showControlPanelDialog() async {
    await Get.bottomSheet(
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
    if (action == AppConstants.action.companyDetails) {
      moveToScreen(appRout: AppRoutes.companyDetailsScreen);
    } else if (action == AppConstants.action.companyTrades) {
      moveToScreen(appRout: AppRoutes.companyTradesScreen);
    } else if (action == AppConstants.action.widgets) {
      moveToScreen(appRout: AppRoutes.widgetsScreen);
    } else if (action == AppConstants.action.settings) {
      moveToScreen(appRout: AppRoutes.settingsScreen);
    } else if (action == AppConstants.action.userPermissions) {
      var arguments = {
        AppConstants.intentKey.userId: UserUtils.getLoginUserId(),
        AppConstants.intentKey.userName: UserUtils.getLoginUserName(),
      };
      moveToScreen(
          appRout: AppRoutes.selectUserListForPermissionScreen,
          arguments: arguments);
    }
  }

  Future<void> moveToScreen(
      {required String appRout, dynamic arguments}) async {
    /* Timer(const Duration(seconds: 2), () async {

    });*/
    var result = await Get.toNamed(appRout, arguments: arguments);
    if (Get.find<AppStorage>().isLocalSequenceChanges()) {
      changeDashboardUserPermissionMultipleSequenceApi(
          isProgress: false,
          isLoadPermissionList: true,
          isChangeSequence: false);
    } else {
      getDashboardUserPermissionsApi(false);
    }
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
      showControlPanelDialog();
    }
  }

  void pullToRefreshData(){
    if (Get.find<AppStorage>().isLocalSequenceChanges()) {
      changeDashboardUserPermissionMultipleSequenceApi(
          isProgress: false,
          isLoadPermissionList: true,
          isChangeSequence: false);
    } else {
      getDashboardUserPermissionsApi(false);
    }
  }
}
