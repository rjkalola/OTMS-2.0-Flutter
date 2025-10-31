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

  DateTime? selectDate, startDate, endDate;
  DateTime? startTime, endTime;

  final formKey = GlobalKey<FormState>();
  final _api = LeaveDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSaveEnable = false.obs,
      isAllDay = true.obs;
  RxString totalDays = "0.0".obs;
  int leaveId = 0;
  LeaveInfo? leaveInfo;
  final title = ''.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      leaveId = arguments[AppConstants.intentKey.leaveId] ?? 0;
      print("leaveId:$leaveId");
    }
    getLeaveDetailsApi();
  }

  void setInitData() {
    if (leaveInfo != null) {
      title.value = 'leave_details'.tr;
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

  void getLeaveDetailsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.leaveDetails(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          LeaveDetailsResponse response =
              LeaveDetailsResponse.fromJson(jsonDecode(responseModel.result!));
          leaveInfo = response.data!;
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
    }
  }
}
