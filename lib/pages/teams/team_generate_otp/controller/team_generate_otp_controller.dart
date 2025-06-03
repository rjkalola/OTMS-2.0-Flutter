import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/teams/team_generate_otp/controller/team_generate_otp_repository.dart';
import 'package:otm_inventory/pages/teams/team_generate_otp/model/team_generate_otp_response.dart';
import 'package:otm_inventory/pages/teams/team_list/controller/team_list_repository.dart';
import 'package:otm_inventory/pages/teams/team_list/model/team_info.dart';
import 'package:otm_inventory/pages/teams/team_list/model/team_list_response.dart';
import 'package:otm_inventory/pages/users/user_list/controller/user_list_repository.dart';
import 'package:otm_inventory/pages/users/user_list/model/user_list_response.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
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
  int teamId = 0;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      teamId = arguments[AppConstants.intentKey.teamId] ?? 0;
    }
    teamGenerateOtpApi();
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
}
