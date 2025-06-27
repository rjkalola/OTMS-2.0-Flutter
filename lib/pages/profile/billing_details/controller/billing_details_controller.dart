import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otm_inventory/pages/profile/billing_details/controller/billing_details_repository.dart';
import 'package:otm_inventory/pages/profile/billing_details/model/billing_info_response.dart';
import 'package:otm_inventory/pages/profile/billing_info/controller/billing_info_repository.dart';
import 'package:otm_inventory/pages/profile/billing_info/model/billing_ifo.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/user_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/pages/profile/personal_info//controller/personal_info_repository.dart';
import 'package:otm_inventory/pages/common/phone_extension_list_dialog.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class BillingDetailsController extends GetxController {
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
  final _api = BillingDetailsRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs, isMainViewVisible = false.obs;
  final billingInfo = BillingInfo().obs;

  @override
  void onInit() {
    super.onInit();
    getBillingInfo();
  }

  void getBillingInfo() async {
    Map<String, dynamic> map = {};
    map["user_id"] = UserUtils.getLoginUserId();
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
}
