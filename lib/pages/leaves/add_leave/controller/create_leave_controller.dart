import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/select_date_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/listener/select_time_listener.dart';
import 'package:belcka/pages/leaves/add_leave/controller/create_leave_repository.dart';
import 'package:belcka/pages/leaves/add_leave/model/leave_type_list_response.dart';
import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateLeaveController extends GetxController
    implements
        SelectItemListener,
        SelectDateListener,
        SelectTimeListener,
        DialogButtonClickListener {
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
      isSaveEnable = false.obs,
      isAllDay = true.obs;
  RxString totalDays = "0.0".obs;
  final leaveTypeList = <ModuleInfo>[].obs;
  int leaveId = 0,userId = 0;

  LeaveInfo? leaveInfo;
  final title = ''.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ?? 0;
      print("userId:$userId");
      leaveInfo = arguments[AppConstants.intentKey.leaveInfo];
    }
    setInitData();
    getLeaveTypesListApi();
  }

  void setInitData() {
    if (leaveInfo != null) {
      title.value = 'edit_leave'.tr;
      leaveId = leaveInfo?.leaveId ?? 0;
      leaveTypeController.value.text = leaveInfo?.leaveName ?? "";
      isAllDay.value = leaveInfo?.isAlldayLeave ?? false;
      if (isAllDay.value) {
        startDateController.value.text = leaveInfo?.startDate ?? "";
        endDateController.value.text = leaveInfo?.endDate ?? "";
        dateController.value.text = leaveInfo?.startDate ?? "";

        if (!StringHelper.isEmptyString(leaveInfo?.startDate ?? "")) {
          startDate = DateUtil.stringToDate(
              (leaveInfo?.startDate ?? ""), DateUtil.DD_MM_YYYY_SLASH);
        }

        if (!StringHelper.isEmptyString(leaveInfo?.endDate ?? "")) {
          endDate = DateUtil.stringToDate(
              (leaveInfo?.endDate ?? ""), DateUtil.DD_MM_YYYY_SLASH);
        }

        if (!StringHelper.isEmptyString(leaveInfo?.startDate ?? "")) {
          selectDate = DateUtil.stringToDate(
              (leaveInfo?.startDate ?? ""), DateUtil.DD_MM_YYYY_SLASH);
        }

        DateTime currentTime = DateTime.now();
        startTime = DateTime(
            currentTime.year, currentTime.month, currentTime.day, 9, 0);
        endTime = DateTime(
            currentTime.year, currentTime.month, currentTime.day, 17, 0);

        startTimeController.value.text =
            DateUtil.timeToString(startTime, DateUtil.HH_MM_24);
        endTimeController.value.text =
            DateUtil.timeToString(endTime, DateUtil.HH_MM_24);
      } else {
        startDateController.value.text = leaveInfo?.startDate ?? "";
        endDateController.value.text = leaveInfo?.endDate ?? "";
        dateController.value.text = leaveInfo?.startDate ?? "";
        startTimeController.value.text = leaveInfo?.startTime ?? "";
        endTimeController.value.text = leaveInfo?.endTime ?? "";

        if (!StringHelper.isEmptyString(leaveInfo?.startDate ?? "")) {
          startDate = DateUtil.stringToDate(
              (leaveInfo?.startDate ?? ""), DateUtil.DD_MM_YYYY_SLASH);
        }

        if (!StringHelper.isEmptyString(leaveInfo?.endDate ?? "")) {
          endDate = DateUtil.stringToDate(
              (leaveInfo?.endDate ?? ""), DateUtil.DD_MM_YYYY_SLASH);
        }

        if (!StringHelper.isEmptyString(leaveInfo?.startDate ?? "")) {
          selectDate = DateUtil.stringToDate(
              (leaveInfo?.startDate ?? ""), DateUtil.DD_MM_YYYY_SLASH);
        }

        DateTime currentTime = DateTime.now();
        if (!StringHelper.isEmptyString(leaveInfo?.startTime ?? "")) {
          startTime = DateUtil.getDateTimeFromHHMM(leaveInfo?.startTime ?? "");
        } else {
          startTime = DateTime(
              currentTime.year, currentTime.month, currentTime.day, 9, 0);
        }

        if (!StringHelper.isEmptyString(leaveInfo?.endTime ?? "")) {
          endTime = DateUtil.getDateTimeFromHHMM(leaveInfo?.endTime ?? "");
        } else {
          endTime = DateTime(
              currentTime.year, currentTime.month, currentTime.day, 17, 0);
        }
      }

      noteController.value.text = leaveInfo?.managerNote ?? "";

      setTotalDays();
    } else {
      title.value = 'add_leave'.tr;
      setInitialDateTime();
      isSaveEnable.value = true;
    }
  }

  void getLeaveTypesListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.getLeaveTypesList(
      queryParameters: map,
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

  void addLeaveApi() async {
    if (valid()) {
      Map<String, dynamic> map = {};
      map["company_id"] = ApiConstants.companyId;
      map["leave_id"] = leaveId;
      map["user_id"] = userId;
      map["is_allday_leave"] = isAllDay.value;
      if (isAllDay.value) {
        map["start_date"] = StringHelper.getText(startDateController.value);
        map["end_date"] = StringHelper.getText(endDateController.value);
        map["start_time"] = "";
        map["end_time"] = "";
      } else {
        map["start_date"] = StringHelper.getText(dateController.value);
        map["end_date"] = StringHelper.getText(dateController.value);
        map["start_time"] = StringHelper.getText(startTimeController.value);
        map["end_time"] = StringHelper.getText(endTimeController.value);
      }
      map["total_time_of_days"] = totalDays.value;
      map["manager_note"] = StringHelper.getText(noteController.value);
      print("map:" + map.toString());

      isLoading.value = true;
      _api.addLeave(
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
            AppUtils.showApiResponseMessage('no_internet'.tr);
          } else if (error.statusMessage!.isNotEmpty) {
            AppUtils.showApiResponseMessage(error.statusMessage);
          }
        },
      );
    }
  }

  void updateLeaveApi() async {
    if (valid()) {
      Map<String, dynamic> map = {};
      map["company_id"] = ApiConstants.companyId;
      map["user_leave_id"] = leaveInfo?.id ?? 0;
      map["leave_id"] = leaveId;
      map["user_id"] = UserUtils.getLoginUserId();
      map["is_allday_leave"] = isAllDay.value;
      if (isAllDay.value) {
        map["start_date"] = StringHelper.getText(startDateController.value);
        map["end_date"] = StringHelper.getText(endDateController.value);
        map["start_time"] = "";
        map["end_time"] = "";
      } else {
        map["start_date"] = StringHelper.getText(dateController.value);
        map["end_date"] = StringHelper.getText(dateController.value);
        map["start_time"] = StringHelper.getText(startTimeController.value);
        map["end_time"] = StringHelper.getText(endTimeController.value);
      }
      map["total_time_of_days"] = totalDays.value;
      map["manager_note"] = StringHelper.getText(noteController.value);
      print("map:" + map.toString());

      isLoading.value = true;
      _api.updateLeave(
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
            AppUtils.showApiResponseMessage('no_internet'.tr);
          } else if (error.statusMessage!.isNotEmpty) {
            AppUtils.showApiResponseMessage(error.statusMessage);
          }
        },
      );
    }
  }

  void deleteLeaveApi() async {
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["user_leave_id"] = leaveInfo?.id ?? 0;
    print("map:" + map.toString());

    isLoading.value = true;
    _api.deleteLeave(
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
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }

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
      isSaveEnable.value = true;
      leaveId = id;
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
          DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_SLASH);
      isSaveEnable.value = true;
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.startDate) {
      final startDateOnly = getDateOnly(date);
      final endDateOnly = getDateOnly(endDate!);
      if (!startDateOnly.isAfter(endDateOnly)) {
        startDate = date;
        startDateController.value.text =
            DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_SLASH);
        isSaveEnable.value = true;
      } else {
        AppUtils.showToastMessage('error_wrong_start_date_selection'.tr);
      }
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.endDate) {
      final startDateOnly = getDateOnly(startDate!);
      final endDateOnly = getDateOnly(date);
      if (!endDateOnly.isBefore(startDateOnly)) {
        endDate = date;
        endDateController.value.text =
            DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_SLASH);
        isSaveEnable.value = true;
      } else {
        AppUtils.showToastMessage('error_wrong_end_date_selection'.tr);
      }
    }
    setTotalDays();
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
      if (!time.isAfter(endTime!)) {
        startTime = time;
        startTimeController.value.text =
            DateUtil.timeToString(time, DateUtil.HH_MM_24);
        isSaveEnable.value = true;
      } else {
        AppUtils.showToastMessage('error_wrong_start_time_selection'.tr);
      }
    } else if (dialogIdentifier ==
        AppConstants.dialogIdentifier.selectShiftEndTime) {
      if (!time.isBefore(startTime!)) {
        endTime = time;
        endTimeController.value.text =
            DateUtil.timeToString(time, DateUtil.HH_MM_24);
        isSaveEnable.value = true;
      } else {
        AppUtils.showToastMessage('error_wrong_end_time_selection'.tr);
      }
    }
    setTotalDays();
  }

  void setInitialDateTime() {
    DateTime currentDay = DateTime.now();
    selectDate = currentDay;
    startDate = currentDay;
    endDate = currentDay.add(Duration(days: 1));
    dateController.value.text =
        DateUtil.dateToString(selectDate, DateUtil.DD_MM_YYYY_SLASH);
    startDateController.value.text =
        DateUtil.dateToString(startDate, DateUtil.DD_MM_YYYY_SLASH);
    endDateController.value.text =
        DateUtil.dateToString(endDate, DateUtil.DD_MM_YYYY_SLASH);

    DateTime currentTime = DateTime.now();
    startTime =
        DateTime(currentTime.year, currentTime.month, currentTime.day, 9, 0);
    endTime =
        DateTime(currentTime.year, currentTime.month, currentTime.day, 17, 0);

    startTimeController.value.text =
        DateUtil.timeToString(startTime, DateUtil.HH_MM_24);
    endTimeController.value.text =
        DateUtil.timeToString(endTime, DateUtil.HH_MM_24);

    setTotalDays();
  }

  void setTotalDays() {
    if (isAllDay.value) {
      final startDateOnly = getDateOnly(startDate!);
      final endDateOnly = getDateOnly(endDate!);
      totalDays.value =
          (endDateOnly.difference(startDateOnly).inDays).toDouble().toString();
    } else {
      DateTime currentDate = DateTime.now();
      final start = DateTime(currentDate.year, currentDate.month,
          currentDate.day, startTime!.hour, startTime!.minute); // 5 PM
      final end = DateTime(currentDate.year, currentDate.month, currentDate.day,
          endTime!.hour, endTime!.minute);

      final timeDifference =
          end.difference(start).inMinutes / 60; // hours difference
      totalDays.value = (timeDifference / 24).toStringAsFixed(2);
    }
  }

  DateTime getDateOnly(DateTime inputDate) {
    return DateTime(inputDate.year, inputDate.month, inputDate.day);
  }

  showRemoveLeaveDialog() async {
    AlertDialogHelper.showAlertDialog(
        "",
        'are_you_sure_you_want_to_delete'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.delete);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.delete) {
      Get.back();
      deleteLeaveApi();
    }
  }
}
