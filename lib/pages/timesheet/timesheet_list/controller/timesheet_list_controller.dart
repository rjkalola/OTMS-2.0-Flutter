import 'dart:convert';

import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/timesheet/timesheet_list/controller/timesheet_list_repository.dart';
import 'package:belcka/pages/timesheet/timesheet_list/model/time_sheet_info.dart';
import 'package:belcka/pages/timesheet/timesheet_list/model/time_sheet_list_response.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_storage.dart';
import '../../../../utils/data_utils.dart';
import '../../../../utils/date_utils.dart';
import '../../../../web_services/api_constants.dart';
import '../../../../web_services/response/response_model.dart';

class TimeSheetListController extends GetxController
    implements MenuItemListener {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isResetEnable = false.obs,
      isEditEnable = false.obs,
      isEditStatusEnable = false.obs,
      isCheckAll = false.obs,
      isViewAmount = false.obs,
      isExpanded = false.obs;
  final RxString title = "".obs;
  final RxInt selectedDateFilterIndex = (1).obs;
  final _api = TimesheetListRepository();
  final timeSheetList = <TimeSheetInfo>[].obs;
  bool isAllUserTimeSheet = false;
  int selectedIndex = 0, selectedTeamId = 0;
  String filterPerDay = "", startDate = "", endDate = "", selectedAction = "";
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
    setInitialFilter();
    if (isAllUserTimeSheet) {
      title.value = 'time_tracking'.tr;
    } else {
      title.value = 'timesheet'.tr;
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
    map["filters"] = appliedFilters;
    map["is_archive"] = false;

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
          isEditEnable.value = false;
          isEditStatusEnable.value = false;
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
    map["is_archive"] = false;

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
          isEditEnable.value = false;
          isEditStatusEnable.value = false;
          // isExpanded.value = false;
          setExpandCollapse();
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

  void archiveTimesheetApi(String? ids) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    // map["company_id"] = ApiConstants.companyId;
    map["ids"] = ids ?? "";
    _api.archiveTimesheet(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          loadTimesheetData(true);
          // shiftList.removeAt(selectedShiftIndex);
          // shiftList.refresh();
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

  void changeTimesheetStatusApi(String? ids, String action) {
    String url = "";
    print("action:" + action);
    if (action == AppConstants.action.lock) {
      url = ApiConstants.lockTimesheet;
    } else if (action == AppConstants.action.unlock) {
      url = ApiConstants.unlockTimesheet;
    } else if (action == AppConstants.action.markAsPaid) {
      url = ApiConstants.paidTimesheet;
    }
    print("url:" + url);
    isLoading.value = true;
    Map<String, dynamic> map = {};
    // map["company_id"] = ApiConstants.companyId;
    map["ids"] = ids ?? "";
    _api.changeTimesheetStatus(
      url: url,
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          loadTimesheetData(true);
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

  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    if (!isAllUserTimeSheet) {
      listItems.add(ModuleInfo(
          name: 'add_expense'.tr, action: AppConstants.action.addExpense));
    } else {
      listItems
          .add(ModuleInfo(name: 'add'.tr, action: AppConstants.action.add));
      listItems
          .add(ModuleInfo(name: 'edit'.tr, action: AppConstants.action.edit));
      listItems.add(
          ModuleInfo(name: 'archive'.tr, action: AppConstants.action.archive));
      listItems.add(ModuleInfo(
          name: 'archived_timesheets'.tr,
          action: AppConstants.action.archivedTimesheet));
      // listItems
      //     .add(ModuleInfo(name: 'share'.tr, action: AppConstants.action.share));
      listItems.add(ModuleInfo(
          name: 'view_amount'.tr, action: AppConstants.action.viewAmount));
      // listItems.add(ModuleInfo(
      //     name: 'history_logs'.tr, action: AppConstants.action.historyLogs));
    }
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  void showActionMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    if (isEditEnable.value) {
      listItems.add(
          ModuleInfo(name: 'archive'.tr, action: AppConstants.action.archive));
    } else if (isEditStatusEnable.value) {
      listItems
          .add(ModuleInfo(name: 'lock'.tr, action: AppConstants.action.lock));
      listItems.add(
          ModuleInfo(name: 'unlock'.tr, action: AppConstants.action.unlock));
      listItems.add(ModuleInfo(
          name: 'mark_as_paid'.tr, action: AppConstants.action.markAsPaid));
    } else {
      listItems.add(
          ModuleInfo(name: 'archive'.tr, action: AppConstants.action.archive));
      listItems
          .add(ModuleInfo(name: 'lock'.tr, action: AppConstants.action.lock));
      listItems.add(
          ModuleInfo(name: 'unlock'.tr, action: AppConstants.action.unlock));
      listItems.add(ModuleInfo(
          name: 'mark_as_paid'.tr, action: AppConstants.action.markAsPaid));
    }
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
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
      selectedAction = info.action ?? "";
      if (info.action == AppConstants.action.add) {
        moveToScreen(AppRoutes.addTimeSheetScreen, null);
      } else if (info.action == AppConstants.action.edit) {
        // showActionMenuItemsDialog(Get.context!);
        isEditStatusEnable.value = true;
      } else if (info.action == AppConstants.action.archive) {
        if (isEditEnable.value) {
          String checkedIds = getCheckedIds();
          if (!StringHelper.isEmptyString(checkedIds)) {
            archiveTimesheetApi(checkedIds);
          }
        } else {
          isEditEnable.value = true;
        }
      } else if (info.action == AppConstants.action.lock) {
        if (isEditStatusEnable.value) {
          String statusIds = getStatusIds();
          print("statusIds:" + statusIds);
          changeTimesheetStatusApi(statusIds, AppConstants.action.lock);
        } else {
          isEditStatusEnable.value = true;
        }
      } else if (info.action == AppConstants.action.unlock) {
        if (isEditStatusEnable.value) {
          String statusIds = getStatusIds();
          print("statusIds:" + statusIds);
          changeTimesheetStatusApi(statusIds, AppConstants.action.unlock);
        } else {
          isEditStatusEnable.value = true;
        }
      } else if (info.action == AppConstants.action.markAsPaid) {
        if (isEditStatusEnable.value) {
          String statusIds = getStatusIds();
          print("statusIds:" + statusIds);
          changeTimesheetStatusApi(statusIds, AppConstants.action.markAsPaid);
        } else {
          isEditStatusEnable.value = true;
        }
      } else if (info.action == AppConstants.action.archivedTimesheet) {
        var arguments = {
          AppConstants.intentKey.isAllUserTimeSheet: isAllUserTimeSheet,
        };
        moveToScreen(AppRoutes.archiveTimeSheetListScreen, arguments);
      } else if (info.action == AppConstants.action.viewAmount) {
        Get.find<AppStorage>().setTimeSheetViewAmountVisible(true);
        isViewAmount.value = true;
      } else if (info.action == AppConstants.action.addExpense) {
        var arguments = {
          AppConstants.intentKey.userId: UserUtils.getLoginUserId(),
        };
        moveToScreen(AppRoutes.addExpenseScreen, arguments);
      }
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
    for (var info in timeSheetList) {
      if (isEditEnable.value) {
        for (var weekData in info.weekLogs!) {
          for (var data in weekData.dayLogs!) {
            if ((data.type ?? "") == "Timesheet") {
              if ((data.isCheck ?? false) == false) {
                isAllSelected = false;
                break;
              }
            }
          }
        }
        if (!isAllSelected) break;
      } else if (isEditStatusEnable.value) {
        for (var weekData in info.weekLogs!) {
          if ((weekData.isCheck ?? false) == false) {
            isAllSelected = false;
            break;
          }
        }
        if (!isAllSelected) break;
      }
    }

    isCheckAll.value = isAllSelected;
  }

  void checkAll() {
    isCheckAll.value = true;
    for (var info in timeSheetList) {
      if (isEditEnable.value) {
        for (var weekData in info.weekLogs!) {
          for (var data in weekData.dayLogs!) {
            if ((data.type ?? "") == "Timesheet") {
              data.isCheck = true;
            }
          }
        }
      } else if (isEditStatusEnable.value) {
        for (var weekData in info.weekLogs!) {
          weekData.isCheck = true;
        }
      }
    }
    timeSheetList.refresh();
  }

  void unCheckAll() {
    isCheckAll.value = false;
    for (var info in timeSheetList) {
      if (isEditEnable.value) {
        for (var weekData in info.weekLogs!) {
          for (var data in weekData.dayLogs!) {
            if ((data.type ?? "") == "Timesheet") {
              data.isCheck = false;
            }
          }
        }
      } else if (isEditStatusEnable.value) {
        for (var weekData in info.weekLogs!) {
          weekData.isCheck = false;
        }
      }
    }
    timeSheetList.refresh();
  }

  String getCheckedIds() {
    List<String> listIds = [];
    for (var info in timeSheetList) {
      for (var weekData in info.weekLogs!) {
        for (var data in weekData.dayLogs!) {
          if (data.isCheck ?? false) {
            if ((data.type ?? "") == "Timesheet") {
              listIds.add(data.id.toString());
            }
          }
        }
      }
    }
    return StringHelper.getCommaSeparatedStringIds(listIds);
  }

  String getStatusIds() {
    List<String> listIds = [];
    for (var info in timeSheetList) {
      for (var weekData in info.weekLogs!) {
        if (weekData.isCheck ?? false) {
          for (var data in weekData.dayLogs!) {
            String timeSheetId = (data.timesheetId ?? 0).toString();
            if (!listIds.contains(timeSheetId)) {
              listIds.add(timeSheetId);
            }
          }
        }
      }
    }
    return StringHelper.getCommaSeparatedStringIds(listIds);
  }

  void setExpandCollapse() {
    for (var info in timeSheetList) {
      info.isExpanded = isExpanded.value;
    }
    timeSheetList.refresh();
  }

  moveToScreen(String path, dynamic arguments) async {
    var result = await Get.toNamed(path, arguments: arguments);
    if (result != null && result) {
      loadTimesheetData(true);
    }
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
    if (isEditEnable.value || isEditStatusEnable.value) {
      unCheckAll();
      isEditEnable.value = false;
      isEditStatusEnable.value = false;
    } else {
      Get.back();
    }
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(Duration(milliseconds: 100), () {
      AppUtils.setStatusBarColor();
    });
  }

  Widget buildStatusIcon(int requestStatus) {
    if (requestStatus == AppConstants.status.lock) {
      return Icon(
        Icons.lock_outline,
        size: 16,
        color: Colors.green,
      );
    } else if (requestStatus == AppConstants.status.unlock) {
      return Icon(
        Icons.lock_open_outlined,
        size: 16,
        color: Colors.red,
      );
    } else if (requestStatus == AppConstants.status.markAsPaid) {
      return Icon(
        Icons.currency_pound_outlined,
        size: 16,
        color: defaultAccentColor_(Get.context!),
      );
    } else {
      return Container();
    }
  }

  void setInitialFilter() {
    if (isAllUserTimeSheet) {
      isViewAmount.value =
          Get.find<AppStorage>().getTimeSheetViewAmountVisible();
      selectedDateFilterIndex.value =
          Get.find<AppStorage>().getTimesheetDateFilterIndex();
      List<DateTime> listDates = DateUtil.getDateWeekRange(
          DataUtils.dateFilterList[selectedDateFilterIndex.value]);
      startDate =
          DateUtil.dateToString(listDates[0], DateUtil.DD_MM_YYYY_SLASH);
      endDate = DateUtil.dateToString(listDates[1], DateUtil.DD_MM_YYYY_SLASH);
    }
  }
}
