import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/teams/generate_company_code/controller/generate_company_code_repository.dart';
import 'package:otm_inventory/pages/teams/team_generate_otp/model/team_generate_otp_response.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class GenerateCompanyCodeController extends GetxController {
  final _api = GenerateCompanyCodeRepository();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final otpController = TextEditingController().obs;
  final mOtpCode = "".obs;
  final otmResendTimeRemaining = 900.obs;
  Timer? _timer;
  String? expireDateTime;

  @override
  void onInit() {
    super.onInit();
    teamGenerateOtpApi();
  }

  void teamGenerateOtpApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.generateCompanyCode(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          TeamGenerateOtpResponse response = TeamGenerateOtpResponse.fromJson(
              jsonDecode(responseModel.result!));
          mOtpCode.value = response.info?.companyOtp ?? "";
          expireDateTime = response.info?.expiredOn ?? "";
          getTimeRemaining();
          startOtpTimeCounter();
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

  void startOtpTimeCounter() {
    // otmResendTimeRemaining.value = 900;
    stopOtpTimeCounter(); // Cancel previous timer if exists
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (otmResendTimeRemaining.value == 0) {
        timer.cancel();
      } else {
        otmResendTimeRemaining.value--;
      }
    });
  }

  void getTimeRemaining() {
    DateTime? expireTime = DateUtil.stringToDate(
        expireDateTime ??
            DateUtil.getCurrentTimeInFormat(
                DateUtil.DD_MM_YYYY_COMMA_TIME_24_SLASH),
        DateUtil.DD_MM_YYYY_COMMA_TIME_24_SLASH);
    DateTime? currentTime = DateTime.now();

    Duration diff = expireTime!.difference(currentTime);
    int totalSeconds = diff.inSeconds;
    otmResendTimeRemaining.value = totalSeconds > 0 ? diff.inSeconds : 0;
  }

  void stopOtpTimeCounter() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    stopOtpTimeCounter();
    super.dispose();
  }
}
