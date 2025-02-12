import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/login/models/RegisterResourcesResponse.dart';
import 'package:otm_inventory/pages/authentication/login/models/VerifyPhoneResponse.dart';
import 'package:otm_inventory/pages/authentication/signup1/controller/signup1_repository.dart';
import 'package:otm_inventory/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:otm_inventory/pages/common/phone_extension_list_dialog.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class SignUp1Controller extends GetxController
    implements SelectPhoneExtensionListener {
  final phoneController = TextEditingController().obs;
  final firstNameController = TextEditingController().obs;
  final lastNameController = TextEditingController().obs;
  final mExtension = AppConstants.defaultPhoneExtension.obs;
  final mFlag = AppConstants.defaultFlagUrl.obs;
  final isPhoneNumberExist = false.obs;
  final phoneNumberErrorMessage = "".obs;
  final formKey = GlobalKey<FormState>();

  final _api = SignUp1Repository();

  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final registerResourcesResponse = RegisterResourcesResponse().obs;

  @override
  void onInit() {
    super.onInit();
    getRegisterResources();
  }

  void signUp() {
    if (valid()) {
      print("Valid");
    } else {
      print("Not Valid");
    }
    update();
  }

  void login(String extension, String phoneNumber, bool isAutoLogin) async {
    if (valid()) {
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

  void checkPhoneNumberExist(String phoneNumber) async {
    if (!StringHelper.isEmptyString(phoneNumber)) {
      if (phoneNumber.length == 10) {
        Map<String, dynamic> map = {};
        map["phone_number"] = phoneNumber;
        multi.FormData formData = multi.FormData.fromMap(map);
        // isLoading.value = true;
        _api.checkPhoneNumberExist(
          formData: formData,
          onSuccess: (ResponseModel responseModel) {
            if (responseModel.statusCode == 200) {
              BaseResponse response =
                  BaseResponse.fromJson(jsonDecode(responseModel.result!));
              if (response.IsSuccess!) {
                isPhoneNumberExist.value = false;
                phoneNumberErrorMessage.value = "";
                // var arguments = {
                //   AppConstants.intentKey.phoneExtension: extension,
                //   AppConstants.intentKey.phoneNumber: phoneNumber,
                // };
                // Get.toNamed(AppRoutes.verifyOtpScreen, arguments: arguments);

                // showSnackBar(response.message!);
              } else {
                isPhoneNumberExist.value = true;
                phoneNumberErrorMessage.value =
                    AppUtils.getStringTr(response.Message ?? "");
                print("Message::::" +
                    AppUtils.getStringTr(response.Message ?? ""));
                // showSnackBar(response.message!);
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
      } else {}
    } else {
      isPhoneNumberExist.value = false;
      phoneNumberErrorMessage.value = 'required_field'.tr;
    }
  }

  bool valid() {
    return formKey.currentState!.validate() && !isPhoneNumberExist.value;
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

  onValueChange() {
    // formKey.currentState!.validate();
  }

  void setRegisterResourcesResponse(RegisterResourcesResponse value) =>
      registerResourcesResponse.value = value;

  void showSnackBar(String message) {
    AppUtils.showSnackBarMessage(message);
  }
}
