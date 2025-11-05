import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:belcka/pages/profile/rates_request/controller/rates_request_repository.dart';
import 'package:belcka/pages/profile/rates_request/model/rate_request_info_response.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';

class RatesRequestController extends GetxController implements DialogButtonClickListener{
  final netPerDayController = TextEditingController().obs;
  final noteController = TextEditingController().obs;
  final formKey = GlobalKey<FormState>();
  final _api = RatesRequestRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs, isMainViewVisible = false.obs;
  final FocusNode focusNode = FocusNode();
  var arguments = Get.arguments;
  final rateRequestInfo = RateRequestInfo().obs;
  String joiningDate = "";
  String tradeName = "";

  double netPerDay = 0.0;
  double grossPerDay = 0.0;
  double cis = 0.0;
  int requestLogId = 0;
  bool fromNotification = false;
  var isShowSaveButton = true.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      requestLogId = arguments["request_log_id"] ?? 0;
      fromNotification =
          arguments[AppConstants.intentKey.fromNotification] ?? false;
      //isShowSaveButton.value = arguments["showButtons"] ?? true;
      getRateRequestInfo();
    }
  }
  void getRateRequestInfo() async {
    Map<String, dynamic> map = {};
    map["request_log_id"] = requestLogId;
    isLoading.value = true;
    _api.getRequestedRateInfo(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          RateRequestInfoResponse response =
          RateRequestInfoResponse.fromJson(jsonDecode(responseModel.result!));

          rateRequestInfo.value = response.info!;

          double oldRate = parseToDouble(rateRequestInfo.value.oldNetRatePerday ?? "");
          double newRate = parseToDouble(rateRequestInfo.value.newNetRatePerday ?? "");

          String netPerDayText = "";
          if (newRate > 0) {
            netPerDay = newRate;
            netPerDayText = "$oldRate > $newRate";
          }
          else{
            netPerDay = oldRate;
            netPerDayText = "$oldRate";
          }

          netPerDayController.value.text = netPerDayText;
          joiningDate = rateRequestInfo.value.joiningDate ?? "";
          tradeName = rateRequestInfo.value.tradeName ?? "";
          cis = netPerDay * 0.20;
          grossPerDay = netPerDay + cis;
          isMainViewVisible.value = true;
        }
        else{
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
  double parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String && value.isNotEmpty) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
  void approveRequest() async {
    isShowSaveButton.value = false;
    Map<String, dynamic> map = {};
    map["log_id"] = requestLogId;
    map["user_id"] = UserUtils.getLoginUserId();
    map["note"] = StringHelper.getText(noteController.value);

    isLoading.value = true;
    _api.wsCallApproveRequest(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          Get.back(result: true);
        }
        else{
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isShowSaveButton.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }

  void rejectRequest() async {
    isShowSaveButton.value = false;
    Map<String, dynamic> map = {};
    map["log_id"] = requestLogId;
    map["user_id"] = UserUtils.getLoginUserId();
    map["reason"] = StringHelper.getText(noteController.value);

    isLoading.value = true;
    _api.wsCallRejectRequest(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          Get.back(result: true);
        }
        else{
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isShowSaveButton.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
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
        false,
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
      approveRequest();
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.reject) {
      Get.back();
      rejectRequest();
    }
  }
  bool valid() {
    return formKey.currentState!.validate();
  }
  void onBackPress() {
    if (fromNotification) {
      Get.offAllNamed(AppRoutes.dashboardScreen);
    } else {
      Get.back();
    }
  }
}
