import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otm_inventory/pages/teams/team_generate_otp/controller/team_generate_otp_repository.dart';
import 'package:otm_inventory/pages/teams/team_generate_otp/model/team_generate_otp_response.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class TeamGenerateOtpController extends GetxController {
  final _api = TeamGenerateOtpRepository();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final otpController = TextEditingController().obs;
  final mOtpCode = "".obs;
  final otmResendTimeRemaining = 900.obs;
  Timer? _timer;
  String initialTime = "";

  int teamId = 0;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      teamId = arguments[AppConstants.intentKey.teamId] ?? 0;
    }
    teamGenerateOtpApi();
    // initialTime = getFormattedDateTime();
    // print("initialTime:" + initialTime);
  }

  void teamGenerateOtpApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["team_id"] = teamId;
    _api.teamGenerateOtp(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          TeamGenerateOtpResponse response = TeamGenerateOtpResponse.fromJson(
              jsonDecode(responseModel.result!));
          mOtpCode.value = response.info?.companyOtp ?? "";
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
    otmResendTimeRemaining.value = 900;
    stopOtpTimeCounter(); // Cancel previous timer if exists
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (otmResendTimeRemaining.value == 0) {
        timer.cancel();
      } else {
        // timeDifferent();
        otmResendTimeRemaining.value--;
      }
    });
  }

  String getFormattedDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat(DateUtil.DD_MM_YYYY_TIME_24_SLASH);
    return formatter.format(now);
  }

  void timeDifferent() {
    String t1 = initialTime;
    String t2 = getFormattedDateTime();
    print("t1:" + t1);
    print("t2:" + t2);
    DateTime? startTime =
        DateUtil.stringToDate(t1, DateUtil.DD_MM_YYYY_TIME_24_SLASH);
    DateTime? endTime =
        DateUtil.stringToDate(t2, DateUtil.DD_MM_YYYY_TIME_24_SLASH);

    // Get the difference
    Duration diff = endTime!.difference(startTime!);

    // Extract hours and minutes
    int hours = diff.inHours;
    int minutes = diff.inMinutes % 60;
    int seconds = diff.inSeconds % 60;

    print(
        "Difference: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}"); // 01:23
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
