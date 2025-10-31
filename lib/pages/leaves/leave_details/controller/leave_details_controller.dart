import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/select_date_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/listener/select_time_listener.dart';
import 'package:belcka/pages/leaves/add_leave/controller/create_leave_repository.dart';
import 'package:belcka/pages/leaves/add_leave/model/leave_type_list_response.dart';
import 'package:belcka/pages/leaves/leave_details/controller/leave_details_repository.dart';
import 'package:belcka/pages/leaves/leave_details/model/leave_details_response.dart';
import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';
import 'package:belcka/routes/app_routes.dart';
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

class LeaveDetailsController extends GetxController
    implements DialogButtonClickListener {
  final leaveTypeController = TextEditingController().obs;
  final startDateController = TextEditingController().obs;
  final endDateController = TextEditingController().obs;
  final dateController = TextEditingController().obs;
  final startTimeController = TextEditingController().obs;
  final endTimeController = TextEditingController().obs;
  final noteController = TextEditingController().obs;
  final requestNoteController = TextEditingController().obs;

  DateTime? selectDate, startDate, endDate;
  DateTime? startTime, endTime;

  final formKey = GlobalKey<FormState>();
  final _api = LeaveDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSaveEnable = false.obs,
      isAllDay = true.obs,
      isFromRequest = false.obs,
      isFromNotification = false.obs;
  RxString totalDays = "0.0".obs;
  RxInt requestStatus = 0.obs;
  int leaveId = 0;
  final leaveInfo = LeaveInfo().obs;
  final title = ''.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      leaveId = arguments[AppConstants.intentKey.leaveId] ?? 0;
      isFromRequest.value = arguments[AppConstants.intentKey.fromRequest] ?? false;
      isFromNotification.value =
          arguments[AppConstants.intentKey.fromNotification] ?? false;
      print("leaveId:$leaveId");
    }
    getLeaveDetailsApi();
  }

  void setInitData() {
    title.value = 'leave_details'.tr;
    // title.value = leaveInfo.value.userName ?? "";
    leaveTypeController.value.text = leaveInfo.value.leaveName ?? "";
    isAllDay.value = leaveInfo.value.isAlldayLeave ?? false;
    requestStatus.value = leaveInfo.value.requestStatus ?? 0;

    if (isAllDay.value) {
      startDateController.value.text = leaveInfo.value.startDate ?? "";
      endDateController.value.text = leaveInfo.value.endDate ?? "";
      dateController.value.text = leaveInfo.value.startDate ?? "";

      if (!StringHelper.isEmptyString(leaveInfo.value.startDate ?? "")) {
        startDate = DateUtil.stringToDate(
            (leaveInfo.value.startDate ?? ""), DateUtil.DD_MM_YYYY_SLASH);
      }

      if (!StringHelper.isEmptyString(leaveInfo.value.endDate ?? "")) {
        endDate = DateUtil.stringToDate(
            (leaveInfo.value.endDate ?? ""), DateUtil.DD_MM_YYYY_SLASH);
      }

      if (!StringHelper.isEmptyString(leaveInfo.value.startDate ?? "")) {
        selectDate = DateUtil.stringToDate(
            (leaveInfo.value.startDate ?? ""), DateUtil.DD_MM_YYYY_SLASH);
      }

      DateTime currentTime = DateTime.now();
      startTime =
          DateTime(currentTime.year, currentTime.month, currentTime.day, 9, 0);
      endTime =
          DateTime(currentTime.year, currentTime.month, currentTime.day, 17, 0);

      startTimeController.value.text =
          DateUtil.timeToString(startTime, DateUtil.HH_MM_24);
      endTimeController.value.text =
          DateUtil.timeToString(endTime, DateUtil.HH_MM_24);
    } else {
      startDateController.value.text = leaveInfo.value.startDate ?? "";
      endDateController.value.text = leaveInfo.value.endDate ?? "";
      dateController.value.text = leaveInfo.value.startDate ?? "";
      startTimeController.value.text = leaveInfo.value.startTime ?? "";
      endTimeController.value.text = leaveInfo.value.endTime ?? "";

      if (!StringHelper.isEmptyString(leaveInfo.value.startDate ?? "")) {
        startDate = DateUtil.stringToDate(
            (leaveInfo.value.startDate ?? ""), DateUtil.DD_MM_YYYY_SLASH);
      }

      if (!StringHelper.isEmptyString(leaveInfo.value.endDate ?? "")) {
        endDate = DateUtil.stringToDate(
            (leaveInfo.value.endDate ?? ""), DateUtil.DD_MM_YYYY_SLASH);
      }

      if (!StringHelper.isEmptyString(leaveInfo.value.startDate ?? "")) {
        selectDate = DateUtil.stringToDate(
            (leaveInfo.value.startDate ?? ""), DateUtil.DD_MM_YYYY_SLASH);
      }

      DateTime currentTime = DateTime.now();
      if (!StringHelper.isEmptyString(leaveInfo.value.startTime ?? "")) {
        startTime =
            DateUtil.getDateTimeFromHHMM(leaveInfo.value.startTime ?? "");
      } else {
        startTime = DateTime(
            currentTime.year, currentTime.month, currentTime.day, 9, 0);
      }

      if (!StringHelper.isEmptyString(leaveInfo.value.endTime ?? "")) {
        endTime = DateUtil.getDateTimeFromHHMM(leaveInfo.value.endTime ?? "");
      } else {
        endTime = DateTime(
            currentTime.year, currentTime.month, currentTime.day, 17, 0);
      }
    }

    noteController.value.text = leaveInfo.value.managerNote ?? "";

    setTotalDays();
  }

  void getLeaveDetailsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["user_leave_id"] = leaveId;
    _api.leaveDetails(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          LeaveDetailsResponse response =
              LeaveDetailsResponse.fromJson(jsonDecode(responseModel.result!));
          leaveInfo.value = response.data!;
          setInitData();
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

  void deleteLeaveApi() async {
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["user_leave_id"] = leaveId;
    print("map:" + map.toString());

    isLoading.value = true;
    CreateLeaveRepository().deleteLeave(
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

  Future<void> approveLeaveApi() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["user_leave_id"] = leaveId;
    // map["note"] = StringHelper.getText(noteController.value);
    _api.approveLeave(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message);
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
        }
      },
    );
  }

  Future<void> rejectLeaveApi() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["user_leave_id"] = leaveId;
    // map["note"] = StringHelper.getText(noteController.value);
    print("map:" + map.toString());
    _api.rejectLeave(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message);
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
        }
      },
    );
  }

  bool valid() {
    return formKey.currentState!.validate();
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

  showActionDialog(String dialogType) async {
    AlertDialogHelper.showAlertDialog(
        "",
        dialogType == AppConstants.dialogIdentifier.approve
            ? 'are_you_sure_you_want_to_approve'.tr
            : 'are_you_sure_you_want_to_reject'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        true,
        this,
        dialogType);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.approve) {
      Get.back();
      approveLeaveApi();
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.reject) {
      Get.back();
      rejectLeaveApi();
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.delete) {
      Get.back();
      deleteLeaveApi();
    }
  }

  void onBackPress() {
    if (isFromNotification.value) {
      Get.offAllNamed(AppRoutes.dashboardScreen);
    } else {
      Get.back();
    }
  }
}
