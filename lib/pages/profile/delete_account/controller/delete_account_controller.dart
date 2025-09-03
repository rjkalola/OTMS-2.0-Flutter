import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/login/controller/login_repository.dart';
import 'package:belcka/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/common/model/user_response.dart';
import 'package:belcka/pages/common/phone_extension_list_dialog.dart';
import 'package:belcka/pages/profile/delete_account/controller/delete_account_repository.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:sms_autofill/sms_autofill.dart';

class DeleteAccountController extends GetxController {

  final formKey = GlobalKey<FormState>();
  final _api = DeleteAccountRepository();

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isOtpViewVisible = false.obs,isOtpVerified = false.obs;
  final otpController = TextEditingController().obs;
  final mOtpCode = "".obs;
  final otmResendTimeRemaining = 30.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    sendOtpApi();
  }
  listenSmsCode() async {
    print("regiestered");
    await SmsAutoFill().listenForCode();
  }
  void sendOtpApi() async {
    Map<String, dynamic> map = {};
    UserInfo info = Get.find<AppStorage>().getUserInfo();
    map["phone"] = info.phone ?? "";
    map["extension"] = info.extension ?? "";
    multi.FormData formData = multi.FormData.fromMap(map);
    isLoading.value = true;
    _api.sendLoginOtpAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          listenSmsCode();
          isOtpViewVisible.value = true;
          startOtpTimeCounter();
          BaseResponse response =
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message!);
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
  void startOtpTimeCounter() {
    otmResendTimeRemaining.value = 30;
    stopOtpTimeCounter(); // Cancel previous timer if exists
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (otmResendTimeRemaining.value == 0) {
        timer.cancel();
      } else {
        otmResendTimeRemaining.value--;
      }
    });
  }
  void stopOtpTimeCounter() {
    _timer?.cancel();
  }
  void deleteAccount() async {
    Map<String, dynamic> map = {};
    map["user_id"] = UserUtils.getLoginUserId();
    map["company_id"] = ApiConstants.companyId;
    isLoading.value = true;
    _api.archive(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          if (responseModel.statusCode == 200) {
            Get.find<AppStorage>().clearAllData();
            Get.offAllNamed(AppRoutes.introductionScreen);
          } else {
            AppUtils.showSnackBarMessage(responseModel.statusMessage!);
          }
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
  void verifyOtpApi(String otp) async {
    Map<String, dynamic> map = {};
    UserInfo info = Get.find<AppStorage>().getUserInfo();
    map["phone"] = info.phone ?? "";
    map["extension"] = info.extension ?? "";
    map["otp"] = otp;

    isLoading.value = true;
    _api.verifyOtpUrl(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          deleteAccount();

        }else{
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
  void onSubmitClick(){
    if (isOtpViewVisible.value) {
      if (!isOtpVerified.value) {
        if (mOtpCode.value.length == 6) {
          verifyOtpApi(mOtpCode.value);
        } else {
          AppUtils.showSnackBarMessage('enter_otp'.tr);
        }
      } else {

      }
    } else {
      sendOtpApi();
    }

  void showSnackBar(String message) {
    AppUtils.showSnackBarMessage(message);
  }
}
}