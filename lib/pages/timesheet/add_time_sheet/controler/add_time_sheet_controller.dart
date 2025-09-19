import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_date_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/listener/select_time_listener.dart';
import 'package:belcka/pages/project/project_info/model/project_list_response.dart';
import 'package:belcka/pages/project/project_list/controller/project_list_repository.dart';
import 'package:belcka/pages/shifts/shift_list/controller/shift_list_repository.dart';
import 'package:belcka/pages/shifts/shift_list/model/shift_list_response.dart';
import 'package:belcka/pages/timesheet/add_time_sheet/controler/add_time_sheet_repository.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_constants.dart';

class AddTimeSheetController extends GetxController
    implements SelectDateListener, SelectTimeListener, SelectItemListener {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isEditEnable = false.obs;
  final formKey = GlobalKey<FormState>();
  final _api = AddTimeSheetRepository();
  final selectDateController = TextEditingController().obs;
  final startTimeController = TextEditingController().obs;
  final endTimeController = TextEditingController().obs;
  final shiftController = TextEditingController().obs;
  final projectController = TextEditingController().obs;
  DateTime? selectDate;
  DateTime? startShiftTime, endShiftTime;
  int projectId = 0,
      shiftId = 0;
  final shiftList = <ModuleInfo>[].obs;
  final projectsList = <ModuleInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      // isAllUserTimeSheet =
      //     arguments[AppConstants.intentKey.isAllUserTimeSheet] ?? false;
    }
    getProjectListApi();
  }

  void addTimesheetWorkLogApi(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["date"] = StringHelper.getText(selectDateController.value);
    map["start_time"] = StringHelper.getText(startTimeController.value);
    map["end_time"] = StringHelper.getText(endTimeController.value);
    map["shift_id"] = shiftId;
    map["project_id"] = projectId;

    _api.addTimesheetWorkLog(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          BaseResponse response =
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
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
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void getProjectListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;

    ProjectListRepository().getProjectList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          ProjectListResponse response =
          ProjectListResponse.fromJson(jsonDecode(responseModel.result!));
          projectsList.clear();
          for (var data in response.info!) {
            projectsList
                .add(ModuleInfo(id: data.id ?? 0, name: data.name ?? ""));
          }
          getShiftListApi();
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        // isLoading.value = false;
      },
      onError: (ResponseModel error) {
        // isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        }
      },
    );
  }

  void getShiftListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["project_id"] = projectId;
    ShiftListRepository().getShiftList(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          ShiftListResponse response =
          ShiftListResponse.fromJson(jsonDecode(responseModel.result!));
          shiftList.clear();
          for (var data in response.info!) {
            if (data.status ?? false) {
              shiftList
                  .add(ModuleInfo(id: data.id ?? 0, name: data.name ?? ""));
            }
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          // isInternetNotAvailable.value = true;
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void showSelectProjectDialog() {
    if (projectsList.isNotEmpty) {
      showDropDownDialog(AppConstants.action.selectProjectDialog,
          'select_project'.tr, projectsList, this);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showSelectShiftDialog() {
    if (shiftList.isNotEmpty) {
      showDropDownDialog(AppConstants.action.selectShiftDialog,
          'select_shift'.tr, shiftList, this);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        DropDownListDialog(
          title: title,
          dialogType: dialogType,
          list: list,
          listener: listener,
          isCloseEnable: true,
          isSearchEnable: true,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.action.selectProjectDialog) {
      projectId = id;
      projectController.value.text = name;
      shiftId = 0;
      shiftController.value.text = "";
      getShiftListApi();
    } else if (action == AppConstants.action.selectShiftDialog) {
      shiftId = id;
      shiftController.value.text = name;
    }
  }

  void showDatePickerDialog(String dialogIdentifier, DateTime? date,
      DateTime firstDate, DateTime lastDate) {
    DateUtil.showDatePickerDialog(
        initialDate: date,
        firstDate: firstDate,
        lastDate: lastDate,
        dialogIdentifier: dialogIdentifier,
        selectDateListener: this);
  }

  @override
  void onSelectDate(DateTime date, String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.selectDate) {
      selectDate = date;
      selectDateController.value.text =
          DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_DASH);
    }
  }

  void showTimePickerDialog(String dialogIdentifier, DateTime? time) {
    DateUtil.showTimePickerDialog(
        initialTime: time,
        dialogIdentifier: dialogIdentifier,
        selectTimeListener: this);
  }

  @override
  void onSelectTime(DateTime time, String dialogIdentifier) {
    if (dialogIdentifier ==
        AppConstants.dialogIdentifier.selectShiftStartTime) {
      startShiftTime = time;
      startTimeController.value.text =
          DateUtil.timeToString(time, DateUtil.HH_MM_24);
    } else if (dialogIdentifier ==
        AppConstants.dialogIdentifier.selectShiftEndTime) {
      endShiftTime = time;
      endTimeController.value.text =
          DateUtil.timeToString(time, DateUtil.HH_MM_24);
    }
  }

  bool valid() {
    return formKey.currentState!.validate();
  }

  void onClickSave() {
    if (valid()) {
      if (!startShiftTime!.isAfter(endShiftTime!)) {
        addTimesheetWorkLogApi(true);
      } else {
        AppUtils.showToastMessage('error_wrong_time_selection'.tr);
      }
    }
  }

  void onBackPress() {
    Get.back();
  }
}
