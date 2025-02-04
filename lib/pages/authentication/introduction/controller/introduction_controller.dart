import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/login/controller/login_repository.dart';
import 'package:otm_inventory/pages/login/models/VerifyPhoneResponse.dart';
import 'package:otm_inventory/pages/otp_verification/model/user_info.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class IntroductionController extends GetxController {
  final phoneController = TextEditingController().obs;
  final mExtension = AppConstants.defaultPhoneExtension.obs;
  final mFlag = AppConstants.defaultFlagUrl.obs;
  final formKey = GlobalKey<FormState>();

  final _api = LoginRepository();

  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  var loginUsers = <UserInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    loginUsers.value = Get.find<AppStorage>().getLoginUsers();
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
              // showSnackBar(response.message!);
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

  bool valid(bool isAutoLogin) {
    if (!isAutoLogin) {
      return formKey.currentState!.validate();
    } else {
      return true;
    }
  }

  void showSnackBar(String message) {
    AppUtils.showSnackBarMessage(message);
  }
}
