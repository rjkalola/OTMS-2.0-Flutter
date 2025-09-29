import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:belcka/pages/profile/billing_request/controller/billing_request_repository.dart';
import 'package:belcka/pages/profile/billing_request/model/billing_request_info.dart';
import 'package:belcka/pages/profile/billing_request/model/billing_request_info_response.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/pages/common/phone_extension_list_dialog.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';

class BillingRequestController extends GetxController {
  final firstNameController = TextEditingController().obs;
  final lastNameController = TextEditingController().obs;
  final middleNameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final postcodeController = TextEditingController().obs;
  final myAddressController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;

  final nameOnUTRController = TextEditingController().obs;
  final utrController = TextEditingController().obs;
  final ninController = TextEditingController().obs;
  final nameOnAccountController = TextEditingController().obs;
  final bankNameController = TextEditingController().obs;
  final accountNumberController = TextEditingController().obs;
  final sortCodeController = TextEditingController().obs;

  final mExtension = AppConstants.defaultPhoneExtension.obs;
  final mExtensionId = AppConstants.defaultPhoneExtensionId.obs;
  final mFlag = AppConstants.defaultFlagUrl.obs;
  final formKey = GlobalKey<FormState>();
  final _api = BillingRequestRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs, isMainViewVisible = false.obs;
  final billingRequestInfo = BillingRequestInfo().obs;
  int requestLogId = 0;
  bool fromNotification = false;
  var isShowSaveButton = true.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      requestLogId = arguments["request_log_id"] ?? 0;
      fromNotification =
          arguments[AppConstants.intentKey.fromNotification] ?? false;
    }
    getBillingRequestInfo();
  }

  void getBillingRequestInfo() async {
    Map<String, dynamic> map = {};
    map["request_log_id"] = requestLogId;
    isLoading.value = true;
    _api.getRequestedBillingInfo(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BillingRequestInfoResponse response =
          BillingRequestInfoResponse.fromJson(jsonDecode(responseModel.result!));

          billingRequestInfo.value = response.info!;
          nameOnUTRController.value.text = billingRequestInfo.value.nameOnUtr ?? "";
          utrController.value.text = billingRequestInfo.value.utrNumber ?? "";
          ninController.value.text = billingRequestInfo.value.ninNumber ?? "";
          nameOnAccountController.value.text = billingRequestInfo.value.nameOnAccount ?? "";
          bankNameController.value.text = billingRequestInfo.value.bankName ?? "";
          accountNumberController.value.text = "${billingRequestInfo.value.accountNo ?? 0}";
          sortCodeController.value.text = billingRequestInfo.value.shortCode ?? "";
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

  void approveRequest() async {
    isShowSaveButton.value = false;
    Map<String, dynamic> map = {};
    map["log_id"] = requestLogId;
    map["user_id"] = UserUtils.getLoginUserId();

    isLoading.value = true;
    _api.wsCallApproveRequest(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          Get.back(result: true);
        }
        else{
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isShowSaveButton.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }

  void rejectRequest(String note) async {
    isShowSaveButton.value = false;
    Map<String, dynamic> map = {};
    map["log_id"] = requestLogId;
    map["user_id"] = UserUtils.getLoginUserId();
    map["reason"] = note;

    isLoading.value = true;
    _api.wsCallRejectRequest(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          Get.back(result: true);
        }
        else{
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isShowSaveButton.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }
  void onBackPress() {
    if (fromNotification) {
      Get.offAllNamed(AppRoutes.dashboardScreen);
    } else {
      Get.back();
    }
  }
}
