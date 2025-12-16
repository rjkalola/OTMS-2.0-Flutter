import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/profile/billing_details_new/model/user_pay_rate_response.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:belcka/pages/profile/billing_details_new/model/billing_info_response.dart';
import 'package:belcka/pages/profile/billing_details_new/controller/billing_details_new_repository.dart';
import 'package:belcka/pages/profile/billing_info/controller/billing_info_repository.dart';
import 'package:belcka/pages/profile/billing_info/model/billing_ifo.dart';
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

class BillingDetailsNewController extends GetxController {
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
  final _api = BillingDetailsNewRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs, isMainViewVisible = false.obs;
  final billingInfo = BillingInfo().obs;
  final userPayRateInfo = UserPayRateInfo().obs;

  String taxInfo = "";
  String address = "";
  String bankDetails = "";
  bool showPayRate = true;
  RxString currentRatePerDay = "".obs;
  bool fromNotification = false;
  int? userId = 0;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      isMainViewVisible.value = false;
      userId = arguments["user_id"] ?? 0;
      fromNotification =
          arguments[AppConstants.intentKey.fromNotification] ?? false;
    }
    else{
      userId = UserUtils.getLoginUserId();
    }
    getBillingInfo();
    //getPayRatePermissionAPI();
  }
  void getPayRatePermissionAPI() async {
    Map<String, dynamic> map = {};
    map["user_id"] = userId;
    map["company_id"] = ApiConstants.companyId;
    _api.getUserPayRatePermission(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          UserPayRateResponse response =
          UserPayRateResponse.fromJson(jsonDecode(responseModel.result!));
          userPayRateInfo.value = response.info!;
          showPayRate = userPayRateInfo.value.showPayRate ?? false;

        }
        else{
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
      },
      onError: (ResponseModel error) {
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }
  double parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String && value.isNotEmpty) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
  void getBillingInfo() async {
    Map<String, dynamic> map = {};
    map["user_id"] = userId;
    map["company_id"] = ApiConstants.companyId;
    isLoading.value = true;
    _api.getBillingInfo(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BillingInfoResponse response =
              BillingInfoResponse.fromJson(jsonDecode(responseModel.result!));
          billingInfo.value = response.info!;
          nameOnUTRController.value.text = billingInfo.value.nameOnUtr ?? "";
          utrController.value.text = billingInfo.value.utrNumber ?? "";
          ninController.value.text = billingInfo.value.ninNumber ?? "";
          nameOnAccountController.value.text = billingInfo.value.nameOnAccount ?? "";
          bankNameController.value.text = billingInfo.value.bankName ?? "";
          accountNumberController.value.text = "${billingInfo.value.accountNo ?? 0}";
          sortCodeController.value.text = billingInfo.value.shortCode ?? "";

          if ((billingInfo.value.utrNumber ?? "").isNotEmpty &&
              (billingInfo.value.ninNumber ?? "").isNotEmpty) {
            taxInfo = "${billingInfo.value.utrNumber} / ${billingInfo.value.ninNumber}";
          }
          else if ((billingInfo.value.utrNumber ?? "").isNotEmpty) {
            taxInfo = billingInfo.value.utrNumber ?? "";
          }
          else if ((billingInfo.value.ninNumber ?? "").isNotEmpty) {
            taxInfo = billingInfo.value.ninNumber ?? "";
          }
          else{
            taxInfo = "";
          }

          if ((billingInfo.value.address ?? "").isNotEmpty){
            address = "${billingInfo.value.address}";
          }
          else{
            address = 'address_postcode'.tr;
          }

          if ((billingInfo.value.shortCode ?? "").isNotEmpty &&
              (billingInfo.value.accountNo ?? "").isNotEmpty) {
            bankDetails = "${billingInfo.value.shortCode ?? ""} / ${billingInfo.value.accountNo ?? ""}";
          }
          else if ((billingInfo.value.shortCode ?? "").isNotEmpty) {
            bankDetails = billingInfo.value.shortCode ?? "";
          }
          else if ((billingInfo.value.accountNo ?? "").isNotEmpty) {
            bankDetails = billingInfo.value.accountNo ?? "";
          }
          else{
            bankDetails = "";
          }

          if (billingInfo.value.is_rate_requested ?? false){
            //newNetRatePerDay

            double oldRate = parseToDouble(billingInfo.value.net_rate_perDay ?? "");
            double newRate = parseToDouble(billingInfo.value.newNetRatePerDay ?? "");

            String netPerDayText = "";
            if (newRate > 0) {
              netPerDayText = "${billingInfo.value.currency ?? ""}$oldRate > ${billingInfo.value.currency ?? ""}$newRate";
            }
            else{
              netPerDayText = "${billingInfo.value.currency ?? ""}$oldRate";
            }
            /*
            currentRatePerDay.value = (billingInfo.value.newNetRatePerDay ?? "").isEmpty ?
            billingInfo.value.net_rate_perDay ?? "" : billingInfo.value.newNetRatePerDay ?? "";
            */

            currentRatePerDay.value = netPerDayText;
          }
          else{
            //oldNetRatePerDay
            String rates = (billingInfo.value.oldNetRatePerDay ?? "").isEmpty ?
            billingInfo.value.net_rate_perDay ?? "" : billingInfo.value.oldNetRatePerDay ?? "";
            currentRatePerDay.value = "${billingInfo.value.currency ?? ""}${rates}";
          }

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

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      getBillingInfo();
    }
  }
  void onBackPress() {
    if (fromNotification) {
      Get.offAllNamed(AppRoutes.dashboardScreen);
    } else {
      Get.back();
    }
  }
}
