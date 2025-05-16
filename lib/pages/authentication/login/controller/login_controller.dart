import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/login/controller/login_repository.dart';
import 'package:otm_inventory/pages/authentication/login/models/RegisterResourcesResponse.dart';
import 'package:otm_inventory/pages/authentication/login/models/VerifyPhoneResponse.dart';
import 'package:otm_inventory/pages/authentication/otp_verification/model/user_info.dart';
import 'package:otm_inventory/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:otm_inventory/pages/common/phone_extension_list_dialog.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class LoginController extends GetxController
    implements SelectPhoneExtensionListener {
  final phoneController = TextEditingController().obs;
  final mExtension = AppConstants.defaultPhoneExtension.obs;
  final mFlag = AppConstants.defaultFlagUrl.obs;
  final formKey = GlobalKey<FormState>();

  final _api = LoginRepository();

  final registerResourcesResponse = RegisterResourcesResponse().obs;
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isOtpViewVisible = false.obs,
      isOtpVerified = false.obs;
  var loginUsers = <UserInfo>[].obs;
  final otpController = TextEditingController().obs;
  final mOtpCode = "".obs;

  @override
  void onInit() {
    super.onInit();
    loginUsers.value = Get.find<AppStorage>().getLoginUsers();
    // getRegisterResources();
  }

  void login(String extension, String phoneNumber, bool isAutoLogin) async {
    if (valid(isAutoLogin)) {
      Map<String, dynamic> map = {};
      map["phone"] = extension + phoneNumber;
      multi.FormData formData = multi.FormData.fromMap(map);
      isLoading.value = true;
      _api.login(
        formData: formData,
        onSuccess: (ResponseModel responseModel) {
          if (responseModel.statusCode == 200) {
            VerifyPhoneResponse response =
                VerifyPhoneResponse.fromJson(jsonDecode(responseModel.result!));
            if (response.isSuccess!) {
              var arguments = {
                AppConstants.intentKey.phoneExtension: extension,
                AppConstants.intentKey.phoneNumber: phoneNumber,
              };
              Get.toNamed(AppRoutes.verifyOtpScreen, arguments: arguments);
              // AppUtils.showApiResponseMessage(response.message!);
            } else {
              AppUtils.showApiResponseMessage(response.message!);
            }
          } else {
            AppUtils.showApiResponseMessage(responseModel.statusMessage!);
          }
          isLoading.value = false;
        },
        onError: (ResponseModel error) {
          isLoading.value = false;
          if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
            AppUtils.showApiResponseMessage('no_internet'.tr);
          } else if (error.statusMessage!.isNotEmpty) {
            AppUtils.showApiResponseMessage(error.statusMessage!);
          }
        },
      );
    }
  }

  void sendOtpApi(int extensionId, String phoneNumber) async {
    if (valid(false)) {
      Map<String, dynamic> map = {};
      map["phone"] = phoneNumber;
      map["extension_id"] = extensionId;
      multi.FormData formData = multi.FormData.fromMap(map);
      isLoading.value = true;
      _api.sendOtpAPI(
        data: map,
        onSuccess: (ResponseModel responseModel) {
          if (responseModel.isSuccess) {
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
          } else if (error.statusMessage!.isNotEmpty) {
            AppUtils.showApiResponseMessage(error.statusMessage!);
          }
        },
      );
    }
  }

  void verifyOtpApi(String otp, int extensionId, String phoneNumber) async {
    if (valid(false)) {
      Map<String, dynamic> map = {};
      map["phone"] = phoneNumber;
      map["extension_id"] = extensionId;
      map["otp"] = otp;
      // multi.FormData formData = multi.FormData.fromMap(map);
      isLoading.value = true;
      _api.verifyOtpUrl(
        data: map,
        onSuccess: (ResponseModel responseModel) {
          if (responseModel.isSuccess) {
            isOtpVerified.value = true;
            BaseResponse response =
                BaseResponse.fromJson(jsonDecode(responseModel.result!));
            // AppUtils.showApiResponseMessage(response.Message!);
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
            AppUtils.showApiResponseMessage(error.statusMessage!);
          }
        },
      );
    }
  }

  bool valid(bool isAutoLogin) {
    if (!isAutoLogin) {
      return formKey.currentState!.validate();
    } else {
      return true;
    }
  }

  void getRegisterResources() {
    isLoading.value = true;
    _api.getRegisterResources(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          setRegisterResourcesResponse(RegisterResourcesResponse.fromJson(
              jsonDecode(responseModel.result!)));
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  void showPhoneExtensionDialog() {
    Get.bottomSheet(
        PhoneExtensionListDialog(
            title: 'select_phone_extension'.tr,
            list: registerResourcesResponse.value.countries!,
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

  void setRegisterResourcesResponse(RegisterResourcesResponse value) =>
      registerResourcesResponse.value = value;
}
