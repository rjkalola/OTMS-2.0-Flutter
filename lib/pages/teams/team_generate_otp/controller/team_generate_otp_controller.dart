import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:belcka/pages/teams/team_generate_otp/controller/team_generate_otp_repository.dart';
import 'package:belcka/pages/teams/team_generate_otp/model/team_generate_otp_response.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';

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
  String? expireDateTime;

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
        // timeDifferent();
        otmResendTimeRemaining.value--;
      }
    });
  }

  void getTimeRemaining() {
    print("expireDateTime:" + (expireDateTime ?? ""));

    DateTime? expireTime = DateUtil.stringToDate(
        expireDateTime ??
            DateUtil.getCurrentTimeInFormat(DateUtil.DD_MM_YYYY_TIME_24_SLASH2),
        DateUtil.DD_MM_YYYY_TIME_24_SLASH2);
    DateTime? currentTime = DateTime.now();

    Duration diff = expireTime!.difference(currentTime);
    int totalSeconds = diff.inSeconds;
    otmResendTimeRemaining.value = totalSeconds > 0 ? diff.inSeconds : 0;

    // print("totalSeconds:" + totalSeconds.toString()); // Output: 3750
    /* // Extract hours and minutes
    int hours = diff.inHours;
    int minutes = diff.inMinutes % 60;
    int seconds = diff.inSeconds % 60;
    print(
        "Difference: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}"); // 01:23*/
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
