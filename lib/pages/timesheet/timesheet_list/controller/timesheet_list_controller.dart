import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/listener/menu_item_listener.dart';
import 'package:otm_inventory/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/controller/timesheet_list_repository.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/model/time_sheet_info.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/model/time_sheet_list_response.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

import '../../../../web_services/api_constants.dart';
import '../../../../web_services/response/response_model.dart';

class TimeSheetListController extends GetxController
    implements MenuItemListener {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isResetEnable = false.obs;
  final RxInt selectedDateFilterIndex = (-1).obs;
  final _api = TimesheetListRepository();
  final timeSheetList = <TimeSheetInfo>[].obs;
  bool isAllUserTimeSheet = false;
  int selectedIndex = 0, selectedTeamId = 0;
  String filterPerDay = "", startDate = "", endDate = "";
  List<TimeSheetInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      isAllUserTimeSheet =
          arguments[AppConstants.intentKey.isAllUserTimeSheet] ?? "";
    }
    loadTimesheetData(true);
  }

  Future<void> loadTimesheetData(bool isProgress) async {
    if (isAllUserTimeSheet) {
      getTimeSheetListAllUsersApi(isProgress);
    } else {
      getTimeSheetListApi(isProgress);
    }
  }

  void getTimeSheetListApi(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["start_date"] = startDate;
    map["end_date"] = endDate;
    map["shift_id"] = "";
    map["filter_per_day"] = filterPerDay;

    _api.getTimeSheetList(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          TimeSheetListResponse response =
              TimeSheetListResponse.fromJson(jsonDecode(responseModel.result!));
          tempList.clear();
          tempList.addAll(response.info ?? []);
          timeSheetList.value = tempList;
          timeSheetList.refresh();
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

  void getTimeSheetListAllUsersApi(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["start_date"] = startDate;
    map["end_date"] = endDate;
    map["shift_id"] = "";
    map["filter_per_day"] = filterPerDay;
    map["company_id"] = ApiConstants.companyId;

    _api.getTimeSheetListAllUsers(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          TimeSheetListResponse response =
              TimeSheetListResponse.fromJson(jsonDecode(responseModel.result!));
          tempList.clear();
          tempList.addAll(response.info ?? []);
          timeSheetList.value = tempList;
          timeSheetList.refresh();
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

  void showMenuItemsDialog(
      BuildContext context, List<ModuleInfo> listItems, String dialogType) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => MenuItemsListBottomDialog(
        list: listItems,
        listener: this,
        dialogType: dialogType,
      ),
    );
  }

  @override
  Future<void> onSelectMenuItem(ModuleInfo info, String dialogType) async {
    if (dialogType == AppConstants.dialogIdentifier.selectDayFilter) {
      isResetEnable.value = true;
      filterPerDay = info.name!.toLowerCase();
      loadTimesheetData(true);
    }
  }

  onClickWorkLogItem(int workLogId, int userId) async {
    var arguments = {
      AppConstants.intentKey.workLogId: workLogId,
      AppConstants.intentKey.userId: userId
    };
    var result =
        await Get.toNamed(AppRoutes.stopShiftScreen, arguments: arguments);
    print("result:" + result.toString());
    if (result != null && result) {
      loadTimesheetData(true);
    }
  }

  void clearFilter() {
    isResetEnable.value = false;
    filterPerDay = "";
    startDate = "";
    endDate = "";
    selectedDateFilterIndex.value = -1;
    loadTimesheetData(true);
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(Duration(milliseconds: 100), () {
      AppUtils.setStatusBarColor();
    });
  }
}
