import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/otp_verification/controller/verify_otp_repository.dart';
import 'package:belcka/pages/common/model/user_response.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'package:dio/dio.dart' as multi;

class VerifyOtpController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final box1 = TextEditingController().obs;
  final box2 = TextEditingController().obs;
  final box3 = TextEditingController().obs;
  final box4 = TextEditingController().obs;
  final mExtension = "+91".obs,
      mPhoneNumber = "8866270586".obs,
      mOtpCode = "".obs;
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isOtpFilled = false.obs;
  final _api = VerifyOtpRepository();
  final otpController = TextEditingController().obs;

  listenSmsCode() async {
    print("regiestered");
    await SmsAutoFill().listenForCode();
  }

  @override
  void onInit() {
    super.onInit();
    listenSmsCode();
  }

  @override
  void dispose() {
    print("unregisterListener");
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  void resetOtpField() {
    // verifyOtpController.otpController.value.clear();
    isOtpFilled.value = false;
    mOtpCode.value = "";
  }

  void onSubmitOtpClick() {
    // if (box1.value.text.toString().isNotEmpty &&
    //     box2.value.text.toString().isNotEmpty &&
    //     box3.value.text.toString().isNotEmpty &&
    //     box4.value.text.toString().isNotEmpty) {
    if (mOtpCode.value.length == 4) {
      // String otp = box1.value.text.toString() +
      //     box2.value.text.toString() +
      //     box3.value.text.toString() +
      //     box4.value.text.toString();

      verifyOtpApi(mOtpCode.value);
      // resetOtpField();
    } else {
      showSnackBar('enter_otp'.tr);
    }
  }

  void verifyOtpApi(String code) async {
    if (formKey.currentState!.validate()) {
      String deviceModelName = await AppUtils.getDeviceName();
      Map<String, dynamic> map = {};
      map["email"] = mExtension.value + mPhoneNumber.value;
      map["verification_code"] = code;
      map["password"] = "";
      map["save_login"] = "0";
      map["user_id"] = "0";
      // map["is_inventory"] = "true";
      map["device_type"] = AppConstants.deviceType;
      map["model_name"] = deviceModelName;
      multi.FormData formData = multi.FormData.fromMap(map);
      print("request parameter:" + map.toString());
      isLoading.value = true;
      _api.verifyOtp(
        formData: formData,
        onSuccess: (ResponseModel responseModel) {
          if (responseModel.statusCode == 200) {
            UserResponse response =
                UserResponse.fromJson(jsonDecode(responseModel.result!));
            if (response.isSuccess!) {
              Get.find<AppStorage>().setUserInfo(response.info!);
              // Get.find<AppStorage>().setAccessToken(response.info!.apiToken!);
              // ApiConstants.accessToken = response.info!.apiToken!;
              print("Token:" + ApiConstants.accessToken);
              AppUtils.saveLoginUser(response.info!);
              Get.offAllNamed(AppRoutes.dashboardScreen);
            } else {
              showSnackBar(response.message!);
            }
          } else {
            showSnackBar(responseModel.statusMessage!);
          }
          isLoading.value = false;
        },
        onError: (ResponseModel error) {
          isLoading.value = false;
          if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
            showSnackBar('no_internet'.tr);
          } else if (error.statusMessage!.isNotEmpty) {
            showSnackBar(error.statusMessage!);
          }
        },
      );
    }
  }

  void resendOtpApi() async {
    Map<String, dynamic> map = {};
    map["phone"] = mExtension.value + mPhoneNumber.value;
    multi.FormData formData = multi.FormData.fromMap(map);
    isLoading.value = true;
    _api.login(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          showSnackBar('otp_resend_success_message'.tr);
        } else {
          showSnackBar(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          showSnackBar('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          showSnackBar(error.statusMessage!);
        }
      },
    );
  }

  void showSnackBar(String message) {
    AppUtils.showSnackBarMessage(message);
  }
}
