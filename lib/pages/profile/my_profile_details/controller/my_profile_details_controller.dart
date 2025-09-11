import 'dart:async';
import 'dart:convert';
import 'package:belcka/pages/profile/my_profile_details/controller/my_profile_details_repository.dart';
import 'package:belcka/pages/profile/my_profile_details/model/my_profile_info_response.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';

class MyProfileDetailsController extends GetxController {
  final nameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;

  final mFlag = AppConstants.defaultFlagUrl.obs;
  final formKey = GlobalKey<FormState>();
  final _api = MyProfileDetailsRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs, isMainViewVisible = false.obs;

  final myProfileInfo = MyProfileInfo().obs;

  @override
  void onInit() {
    super.onInit();
    getProfileAPI();
  }

  void getProfileAPI() async {
    Map<String, dynamic> map = {};
    map["user_id"] = UserUtils.getLoginUserId();
    map["company_id"] = ApiConstants.companyId;
    isLoading.value = true;
    _api.getProfile(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          MyProfileInfoResponse response =
          MyProfileInfoResponse.fromJson(jsonDecode(responseModel.result!));
          myProfileInfo.value = response.info!;
          nameController.value.text = myProfileInfo.value.userName ?? "";
          phoneController.value.text = myProfileInfo.value.phoneWithExtension ?? "";
          emailController.value.text = myProfileInfo.value.email ?? "";
          isMainViewVisible.value = true;
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

}