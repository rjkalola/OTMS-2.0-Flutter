import 'dart:convert';
import 'package:belcka/pages/common/model/user_response.dart';
import 'package:belcka/pages/profile/billing_info/model/billing_ifo.dart';
import 'package:belcka/pages/profile/my_profile_details/model/my_profile_info_response.dart';
import 'package:belcka/pages/profile/user_code/controller/user_code_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCodeController extends GetxController{

  final userCodeController = TextEditingController().obs;
  final formKey = GlobalKey<FormState>();
  final _api = UserCodeRepository();

  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs, isMainViewVisible = false.obs;

  final FocusNode focusNode = FocusNode();

  var arguments = Get.arguments;
  RxBool isSaveEnabled = false.obs;
  bool isDataChanged = false;
  Map<String, dynamic> initialData = {};
  final userInfo = UserUtils.getUserInfo().obs;
  int? userId = UserUtils.getLoginUserId();

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ??
          UserUtils.getLoginUserId();
    }
    getProfileAPI();
  }

  void setInitData() {
    final code = userInfo.value.userCode ?? "";
    userCodeController.value.text = code;

    initialData = {
      "userCode": code.trim(),
    };

    setupListeners();

    checkForChanges();
  }

  void setupListeners() {
    userCodeController.value.removeListener(checkForChanges);
    userCodeController.value.addListener(checkForChanges);
  }

  void checkForChanges() {
    final currentData = {
      "userCode": userCodeController.value.text.trim(),
    };
    isSaveEnabled.value = jsonEncode(initialData) != jsonEncode(currentData);
  }

  @override
  void onClose() {
    userCodeController.value.dispose();
    super.onClose();
  }

  void getProfileAPI() async {
    Map<String, dynamic> map = {};
    map["user_id"] = userId;
    map["company_id"] = ApiConstants.companyId;
    isLoading.value = true;
    _api.getProfile(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          MyProfileInfoResponse response =
          MyProfileInfoResponse.fromJson(jsonDecode(responseModel.result!));
          userInfo.value = response.info!;
          isMainViewVisible.value = true;
          setInitData();

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
  void updateProfileAPI() async {
    Map<String, dynamic> map = {};
    map["user_code"] = StringHelper.getText(userCodeController.value);
    map["user_id"] = UserUtils.getLoginUserId();

    multi.FormData formData = multi.FormData.fromMap(map);
    print("reques value:" + map.toString());

    isLoading.value = true;
    _api.updateProfile(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          UserResponse response =
          UserResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            isDataChanged = true;
            onBackPress();
          }
          else{
            AppUtils.showApiResponseMessage(response.message);
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
        }
      },
    );
  }

  bool valid() {
    return formKey.currentState!.validate();
  }
  void onBackPress() {
    Get.back(result: isDataChanged);
  }
}
