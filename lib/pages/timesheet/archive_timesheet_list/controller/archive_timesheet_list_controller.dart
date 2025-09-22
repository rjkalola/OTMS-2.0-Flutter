import 'dart:convert';

import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/timesheet/timesheet_list/controller/timesheet_list_repository.dart';
import 'package:belcka/pages/timesheet/timesheet_list/model/time_sheet_info.dart';
import 'package:belcka/pages/timesheet/timesheet_list/model/time_sheet_list_response.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../web_services/api_constants.dart';
import '../../../../web_services/response/response_model.dart';

class ArchiveTimesheetListController extends GetxController
    implements MenuItemListener {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isResetEnable = false.obs,
      isCheckAll = false.obs,
      isChecked = false.obs;
  final RxInt selectedDateFilterIndex = (1).obs;
  final _api = TimesheetListRepository();
  final timeSheetList = <TimeSheetInfo>[].obs;
  bool isAllUserTimeSheet = false;
  int selectedIndex = 0, selectedTeamId = 0;
  String filterPerDay = "", startDate = "", endDate = "";
  List<TimeSheetInfo> tempList = [];
  Map<String, String> appliedFilters = {};

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      isAllUserTimeSheet =
          arguments[AppConstants.intentKey.isAllUserTimeSheet] ?? false;
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
    // map["shift_id"] = "";
    // map["filter_per_day"] = filterPerDay;
    map["filters"] = appliedFilters;
    map["is_archive"] = true;

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

          print("Size:" + response.info!.length.toString());
          for (var info in response.info!) {
            for (var data in info.dayLogs!) {
              print("names:" + data.shiftName!);
            }
          }
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
    // map["shift_id"] = "";
    // map["filter_per_day"] = filterPerDay;
    map["company_id"] = ApiConstants.companyId;
    map["filters"] = jsonEncode(appliedFilters);
    map["is_archive"] = true;

    _api.getTimeSheetListAllUsers(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          TimeSheetListResponse response =
              TimeSheetListResponse.fromJson(jsonDecode(responseModel.result!));
          print("List Size:" + response.info!.length.toString());
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

  void unArchiveTimesheetApi(String? ids) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    // map["company_id"] = ApiConstants.companyId;
    map["ids"] = ids ?? "";
    _api.unArchiveTimesheet(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showApiResponseMessage('no_internet'.tr);
          // Utils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void showFilterMenuItemsDialog(
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
    print("onSelectMenuItem");
    if (dialogType == AppConstants.dialogIdentifier.selectDayFilter) {
      // isResetEnable.value = true;
      filterPerDay = info.name!.toLowerCase();
      loadTimesheetData(true);
    } else {
      if (info.action == AppConstants.action.archive) {
        String checkedIds = getCheckedIds();
        if (!StringHelper.isEmptyString(checkedIds)) {
          // archiveTimesheetApi(checkedIds);
        }
      }
    }
  }

  moveToScreen(String path, dynamic arguments) async {
    var result = await Get.toNamed(path, arguments: arguments);
    if (result != null && result) {
      // getUserWorkLogListApi();
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

  void checkSelectAll() {
    bool isAllSelected = true;
    isChecked.value = false;
    for (var info in timeSheetList) {
      for (var weekData in info.weekLogs!) {
        for (var data in weekData.dayLogs!) {
          if ((data.isCheck ?? false) == false) {
            isAllSelected = false;
          }
          if ((data.isCheck ?? false)) {
            isChecked.value = true;
          }
        }
      }
      // if (!isAllSelected) break;
    }

    isCheckAll.value = isAllSelected;
  }

  void checkAll() {
    isCheckAll.value = true;
    for (var info in timeSheetList) {
      for (var weekData in info.weekLogs!) {
        for (var data in weekData.dayLogs!) {
          data.isCheck = true;
        }
      }
    }
    if (timeSheetList.isNotEmpty) isChecked.value = true;
    timeSheetList.refresh();
  }

  void unCheckAll() {
    isCheckAll.value = false;
    for (var info in timeSheetList) {
      for (var weekData in info.weekLogs!) {
        for (var data in weekData.dayLogs!) {
          data.isCheck = false;
        }
      }
    }
    isChecked.value = false;
    timeSheetList.refresh();
  }

  String getCheckedIds() {
    List<String> listIds = [];
    for (var info in timeSheetList) {
      for (var weekData in info.weekLogs!) {
        for (var data in weekData.dayLogs!) {
          if (data.isCheck ?? false) {
            listIds.add(data.id.toString());
          }
        }
      }
    }
    return StringHelper.getCommaSeparatedStringIds(listIds);
  }

  Future<void> moveToTimesheetFilters() async {
    var arguments = {
      AppConstants.intentKey.filterType:
          AppConstants.filterType.timesheetFilter,
      AppConstants.intentKey.filterData: appliedFilters,
    };
    var result =
        await Get.toNamed(AppRoutes.filterScreen, arguments: arguments);
    if (result != null) {
      isResetEnable.value = true;
      appliedFilters = result;
      loadTimesheetData(true);
    }
  }

  void onBackPress() {
    Get.back();
  }
}
