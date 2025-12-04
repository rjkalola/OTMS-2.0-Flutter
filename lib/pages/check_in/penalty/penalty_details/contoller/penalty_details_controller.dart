import 'dart:convert';

import 'package:belcka/pages/check_in/penalty/penalty_list/model/penalty_info.dart';
import 'package:belcka/pages/check_in/work_log_request/controller/work_log_request_repository.dart';
import 'package:belcka/pages/check_in/work_log_request/model/work_log_details_info.dart';
import 'package:belcka/pages/check_in/work_log_request/model/work_log_request_details_response.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/app_constants.dart';
import '../../../../../utils/date_utils.dart';

class PenaltyDetailsController extends GetxController
    implements DialogButtonClickListener {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isLocationLoaded = true.obs,
      isDataUpdated = false.obs,
      isMainViewVisible = false.obs;
  final formKey = GlobalKey<FormState>();
  final RxString startTime = "".obs, stopTime = "".obs;
  final RxInt status = 0.obs;
  final _api = WorkLogRequestRepository();
  final noteController = TextEditingController().obs;
  final displayNoteController = TextEditingController().obs;
  final penaltyInfo = PenaltyInfo().obs;
  int requestLogId = 0;
  bool fromNotification = false;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      requestLogId = arguments[AppConstants.intentKey.ID] ?? 0;
      fromNotification =
          arguments[AppConstants.intentKey.fromNotification] ?? false;
    }
    // getWorkLogRequestDetails();
  }

  // Future<void> getWorkLogRequestDetails() async {
  //   isLoading.value = true;
  //   Map<String, dynamic> map = {};
  //   map["request_log_id"] = requestLogId;
  //   _api.getWorkLogRequestDetails(
  //     queryParameters: map,
  //     onSuccess: (ResponseModel responseModel) {
  //       if (responseModel.isSuccess) {
  //         isMainViewVisible.value = true;
  //         WorkLogRequestDetailsResponse response =
  //             WorkLogRequestDetailsResponse.fromJson(
  //                 jsonDecode(responseModel.result!));
  //         workLogInfo.value = response.info!;
  //         startTime.value =
  //             changeFullDateToSortTime(workLogInfo.value.workStartTime);
  //         stopTime.value =
  //             changeFullDateToSortTime(workLogInfo.value.workEndTime);
  //         displayNoteController.value.text = workLogInfo.value.note ?? "";
  //         status.value = workLogInfo.value.status ?? 0;
  //
  //         print("Olds start:" + workLogInfo.value.oldStartTime!);
  //         print("Olds end:" + workLogInfo.value.oldEndTime!);
  //         print("oldPayableWorkSeconds:" +
  //             workLogInfo.value.oldPayableWorkSeconds!.toString());
  //         // locationRequest();
  //         // appLifeCycle();
  //       } else {
  //         AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
  //       }
  //       isLoading.value = false;
  //     },
  //     onError: (ResponseModel error) {
  //       isLoading.value = false;
  //       if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
  //         // isInternetNotAvailable.value = true;
  //         AppUtils.showApiResponseMessage('no_internet'.tr);
  //       }
  //     },
  //   );
  // }
  //
  // Future<void> workLogRequestApproveRejectApi(int status) async {
  //   isLoading.value = true;
  //   Map<String, dynamic> map = {};
  //   map["request_worklog_id"] = workLogInfo.value.requestLogId ?? 0;
  //   map["status"] = status;
  //   map["user_id"] = workLogInfo.value.userId ?? 0;
  //   map["note"] = StringHelper.getText(noteController.value);
  //
  //   _api.workLogRequestApproveReject(
  //     data: map,
  //     onSuccess: (ResponseModel responseModel) {
  //       if (responseModel.isSuccess) {
  //         BaseResponse response =
  //             BaseResponse.fromJson(jsonDecode(responseModel.result!));
  //         AppUtils.showApiResponseMessage(response.Message);
  //         isDataUpdated.value = true;
  //         onBackPress();
  //       } else {
  //         AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
  //       }
  //       isLoading.value = false;
  //     },
  //     onError: (ResponseModel error) {
  //       isLoading.value = false;
  //       if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
  //         // isInternetNotAvailable.value = true;
  //         AppUtils.showApiResponseMessage('no_internet'.tr);
  //       }
  //     },
  //   );
  // }

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
      // workLogRequestApproveRejectApi(AppConstants.status.approved);
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.reject) {
      Get.back();
      // workLogRequestApproveRejectApi(AppConstants.status.rejected);
    }
  }

  void onBackPress() {
    if (fromNotification) {
      Get.offAllNamed(AppRoutes.dashboardScreen);
    } else {
      Get.back(result: isDataUpdated.value);
    }
  }

  bool valid() {
    return formKey.currentState!.validate();
  }

  String changeFullDateToSortTime(String? date) {
    return !StringHelper.isEmptyString(date)
        ? DateUtil.changeDateFormat(
            date!, DateUtil.DD_MM_YYYY_TIME_24_SLASH2, DateUtil.HH_MM_24)
        : "";
  }
}
