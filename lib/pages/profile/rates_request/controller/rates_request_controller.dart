import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

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

class RatesRequestController extends GetxController{
  final netPerDayController = TextEditingController().obs;
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

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      requestLogId = arguments["request_log_id"] ?? 0;
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
    Map<String, dynamic> map = {};
    map["log_id"] = requestLogId;
    map["user_id"] = UserUtils.getLoginUserId();

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
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }

  void rejectRequest(String note) async {
    Map<String, dynamic> map = {};
    map["log_id"] = requestLogId;
    map["user_id"] = UserUtils.getLoginUserId();
    map["reason"] = note;

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
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }
}
