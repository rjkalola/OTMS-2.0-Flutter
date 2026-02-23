import 'dart:async';
import 'dart:convert';

import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/login/controller/login_repository.dart';
import 'package:belcka/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/common/model/user_response.dart';
import 'package:belcka/pages/common/phone_extension_list_dialog.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginController extends GetxController
    implements SelectPhoneExtensionListener {
  final phoneController = TextEditingController().obs;
  final mExtension = AppConstants.defaultPhoneExtension.obs;
  final mFlag = AppConstants.defaultFlagUrl.obs;
  final formKey = GlobalKey<FormState>();

  final _api = LoginRepository();

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isOtpViewVisible = false.obs;
  var loginUsers = <UserInfo>[].obs;
  final otpController = TextEditingController().obs;
  final mOtpCode = "".obs;
  final otmResendTimeRemaining = 30.obs;
  Timer? _timer;

  listenSmsCode() async {
    print("regiestered");
    await SmsAutoFill().listenForCode();
  }

  @override
  void onInit() {
    super.onInit();
    loginUsers.value = Get.find<AppStorage>().getLoginUsers();
    // getRegisterResources();
  }

  void login() async {
    if (valid(false)) {
      Map<String, dynamic> map = {};
      map["phone"] = StringHelper.getPhoneNumberText(phoneController.value);
      map["extension"] = mExtension.value;
      map["otp"] = mOtpCode.value;
      map["device_type"] = AppConstants.deviceType;
      // multi.FormData formData = multi.FormData.fromMap(map);
      isLoading.value = true;
      _api.login(
        data: map,
        onSuccess: (ResponseModel responseModel) {
          if (responseModel.isSuccess) {
            UserResponse response =
                UserResponse.fromJson(jsonDecode(responseModel.result!));
            AppUtils.showApiResponseMessage(response.message ?? "");
            int companyId = response.info?.companyId ?? 0;
            Get.find<AppStorage>().setUserInfo(response.info!);
            Get.find<AppStorage>()
                .setAccessToken(response.info!.apiToken ?? "");
            ApiConstants.accessToken = response.info!.apiToken ?? "";
            Get.find<AppStorage>().setCompanyId(companyId);
            ApiConstants.companyId = companyId;
            print("Token:" + ApiConstants.accessToken);
            AppUtils.saveLoginUser(response.info!);
            if ((response.info!.companyId ?? 0) != 0) {
              Get.offAllNamed(AppRoutes.dashboardScreen);
            } else {
              if (UserUtils.getLoginUserId() != 0) {
                var arguments = {AppConstants.intentKey.fromSignUpScreen: true};
                Get.offAllNamed(AppRoutes.switchCompanyScreen,
                    arguments: arguments);
              }
            }
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
  }

  void sendOtpApi() async {
    Map<String, dynamic> map = {};
    map["phone"] = StringHelper.getPhoneNumberText(phoneController.value);
    map["extension"] = mExtension.value;
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

  // void verifyOtpApi() async {
  //   Map<String, dynamic> map = {};
  //   map["phone"] = phoneController.value.text;
  //   map["extension"] = mExtension.value;
  //   map["otp"] = mOtpCode.value;
  //   // multi.FormData formData = multi.FormData.fromMap(map);
  //   isLoading.value = true;
  //   _api.verifyOtpUrl(
  //     data: map,
  //     onSuccess: (ResponseModel responseModel) {
  //       if (responseModel.isSuccess) {
  //         isOtpVerified.value = true;
  //         // BaseResponse response =
  //         //     BaseResponse.fromJson(jsonDecode(responseModel.result!));
  //         // AppUtils.showApiResponseMessage(response.Message!);
  //         login();
  //       } else {
  //         AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
  //       }
  //       isLoading.value = false;
  //     },
  //     onError: (ResponseModel error) {
  //       isLoading.value = false;
  //       if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
  //         AppUtils.showApiResponseMessage('no_internet'.tr);
  //       }
  //     },
  //   );
  // }

  bool valid(bool isAutoLogin) {
    if (!isAutoLogin) {
      return formKey.currentState!.validate();
    } else {
      return true;
    }
  }

  void showPhoneExtensionDialog() {
    Get.bottomSheet(
        PhoneExtensionListDialog(
            title: 'select_country_code'.tr,
            list: DataUtils.getPhoneExtensionList(),
            listener: this),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectPhoneExtension(
      int id, String extension, String flag, String country) {
    mFlag.value = flag;
    mExtension.value = extension;
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

  @override
  void dispose() {
    stopOtpTimeCounter(); // Clean up
    SmsAutoFill().unregisterListener();
    super.dispose();
  }
}
