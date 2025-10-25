import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_date_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/listener/select_time_listener.dart';
import 'package:belcka/pages/leaves/add_leave/controller/create_leave_repository.dart';
import 'package:belcka/pages/leaves/add_leave/model/leave_type_list_response.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateLeaveController extends GetxController
    implements SelectItemListener, SelectDateListener, SelectTimeListener {
  final leaveTypeController = TextEditingController().obs;
  final startDateController = TextEditingController().obs;
  final endDateController = TextEditingController().obs;
  final dateController = TextEditingController().obs;
  final startTimeController = TextEditingController().obs;
  final endTimeController = TextEditingController().obs;
  final noteController = TextEditingController().obs;

  DateTime? selectDate, startDate, endDate;
  DateTime? startTime, endTime;

  final formKey = GlobalKey<FormState>();
  final _api = CreateLeaveRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSaveEnable = true.obs,
      isAllDay = true.obs;
  RxString totalDays = "0.0".obs;
  final leaveTypeList = <ModuleInfo>[].obs;
  int leaveId = 0;

  // TeamInfo? teamInfo;
  final title = ''.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      // teamInfo = arguments[AppConstants.intentKey.teamInfo];
    }
    setInitData();
    getLeaveTypesListApi();
  }

  void setInitData() {
    // if (teamInfo != null) {
    //   title.value = 'Edit Team'.tr;
    //   teamNameController.value.text = teamInfo?.name ?? "";
    //   supervisorController.value.text = teamInfo?.supervisorName ?? "";
    //   supervisorId = teamInfo?.supervisorId ?? 0;
    //   teamMembersList.addAll(teamInfo?.teamMembers ?? []);
    // } else {
    //   title.value = 'create_new_team'.tr;
    //   isSaveEnable.value = true;
    // }
    title.value = 'add_leave'.tr;
  }

  void getLeaveTypesListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.getLeaveTypesList(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          LeaveTypeListResponse response =
              LeaveTypeListResponse.fromJson(jsonDecode(responseModel.result!));
          List<ModuleInfo> listItems = [];
          for (var info in response.info!) {
            listItems.add(ModuleInfo(id: info.id, name: info.name));
          }
          leaveTypeList.value = listItems;
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

  // void createTeamApi() async {
  //   if (valid()) {
  //     Map<String, dynamic> map = {};
  //     map["company_id"] = ApiConstants.companyId;
  //     map["supervisor_id"] = supervisorId;
  //     map["name"] = StringHelper.getText(teamNameController.value);
  //     map["team_member_ids"] =
  //         UserUtils.getCommaSeparatedIdsString(teamMembersList);
  //     isLoading.value = true;
  //     _api.addTeam(
  //       data: map,
  //       onSuccess: (ResponseModel responseModel) {
  //         if (responseModel.isSuccess) {
  //           BaseResponse response =
  //               BaseResponse.fromJson(jsonDecode(responseModel.result!));
  //           AppUtils.showApiResponseMessage(response.Message ?? "");
  //           Get.back(result: true);
  //         } else {
  //           AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
  //         }
  //         isLoading.value = false;
  //       },
  //       onError: (ResponseModel error) {
  //         isLoading.value = false;
  //         if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
  //           AppUtils.showApiResponseMessage('no_internet'.tr);
  //         } else if (error.statusMessage!.isNotEmpty) {
  //           AppUtils.showApiResponseMessage(error.statusMessage);
  //         }
  //       },
  //     );
  //   }
  // }
  //
  // void updateTeamApi() async {
  //   if (valid()) {
  //     Map<String, dynamic> map = {};
  //     map["id"] = teamInfo?.id ?? 0;
  //     map["company_id"] = ApiConstants.companyId;
  //     map["supervisor_id"] = supervisorId;
  //     map["name"] = StringHelper.getText(teamNameController.value);
  //     map["team_member_ids"] =
  //         UserUtils.getCommaSeparatedIdsString(teamMembersList);
  //     isLoading.value = true;
  //     _api.updateTeam(
  //       data: map,
  //       onSuccess: (ResponseModel responseModel) {
  //         if (responseModel.isSuccess) {
  //           BaseResponse response =
  //               BaseResponse.fromJson(jsonDecode(responseModel.result!));
  //           AppUtils.showApiResponseMessage(response.Message ?? "");
  //           Get.back(result: true);
  //         } else {
  //           AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
  //         }
  //         isLoading.value = false;
  //       },
  //       onError: (ResponseModel error) {
  //         isLoading.value = false;
  //         if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
  //           AppUtils.showApiResponseMessage('no_internet'.tr);
  //         } else if (error.statusMessage!.isNotEmpty) {
  //           AppUtils.showApiResponseMessage(error.statusMessage);
  //         }
  //       },
  //     );
  //   }
  // }

  bool valid() {
    return formKey.currentState!.validate();
  }

  void showSelectLeaveTypeDialog() {
    if (leaveTypeList.isNotEmpty) {
      showDropDownDialog(AppConstants.action.selectLeaveTypeDialog,
          'leave_type'.tr, leaveTypeList, this);
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
    if (action == AppConstants.action.selectLeaveTypeDialog) {
      leaveTypeController.value.text = name;
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
      dateController.value.text =
          DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_DASH);
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.startDate) {
      startDate = date;
      startDateController.value.text =
          DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_DASH);
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.endDate) {
      endDate = date;
      endDateController.value.text =
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
      startTime = time;
      startTimeController.value.text =
          DateUtil.timeToString(time, DateUtil.HH_MM_24);
    } else if (dialogIdentifier ==
        AppConstants.dialogIdentifier.selectShiftEndTime) {
      endTime = time;
      endTimeController.value.text =
          DateUtil.timeToString(time, DateUtil.HH_MM_24);
    }
  }
}
