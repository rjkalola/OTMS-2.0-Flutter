import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otm_inventory/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:otm_inventory/pages/profile/billing_info/controller/billing_info_repository.dart';
import 'package:otm_inventory/pages/profile/billing_info/model/billing_ifo.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/utils/user_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/pages/profile/personal_info//controller/personal_info_repository.dart';
import 'package:otm_inventory/pages/common/phone_extension_list_dialog.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class BillingInfoController extends GetxController
    implements SelectPhoneExtensionListener {
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
  final _api = BillingInfoRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final billingInfo = BillingInfo().obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      billingInfo.value = arguments[AppConstants.intentKey.billingInfo];
      setInitData();
    }
    billingInfo.value.userId = UserUtils.getLoginUserId();
    billingInfo.value.companyId = ApiConstants.companyId;
  }
  void setInitData() {
    firstNameController.value.text = billingInfo.value.firstName ?? "";
    lastNameController.value.text = billingInfo.value.lastName ?? "";
    middleNameController.value.text = billingInfo.value.middleName ?? "";
    emailController.value.text = billingInfo.value.email ?? "";
    postcodeController.value.text = billingInfo.value.postCode ?? "";
    myAddressController.value.text = billingInfo.value.address ?? "";
    mExtension.value = billingInfo.value.extension ?? "";
    phoneController.value.text = billingInfo.value.phone ?? "";
    nameOnUTRController.value.text = billingInfo.value.nameOnUtr ?? "";
    utrController.value.text = billingInfo.value.utrNumber ?? "";
    ninController.value.text = billingInfo.value.ninNumber ?? "";
    nameOnAccountController.value.text = billingInfo.value.nameOnAccount ?? "";
    bankNameController.value.text = billingInfo.value.bankName ?? "";
    accountNumberController.value.text = billingInfo.value.accountNo ?? "";
    sortCodeController.value.text = billingInfo.value.shortCode ?? "";
  }
  void addBillingInfoAPI() async {
    // Map<String, dynamic> map = {};
    // map["company_id"] = ApiConstants.companyId;
    // map["supervisor_id"] = supervisorId;
    // map["name"] = StringHelper.getText(teamNameController.value);
    // map["team_member_ids"] =
    //     UserUtils.getCommaSeparatedIdsString(teamMembersList);
    isLoading.value = true;
    _api.addBillingInfo(
      data: jsonEncode(billingInfo),
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          Get.back(result: true);
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
  void updateBillingInfoAPI() async {
    // Map<String, dynamic> map = {};
    // map["company_id"] = ApiConstants.companyId;
    // map["supervisor_id"] = supervisorId;
    // map["name"] = StringHelper.getText(teamNameController.value);
    // map["team_member_ids"] =
    //     UserUtils.getCommaSeparatedIdsString(teamMembersList);
    isLoading.value = true;
    _api.updateBillingInfo(
      data: jsonEncode(billingInfo),
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          Get.back(result: true);
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
  void onSubmit() {
    if (valid()) {
      billingInfo.value.firstName =
          StringHelper.getText(firstNameController.value);
      billingInfo.value.lastName =
          StringHelper.getText(lastNameController.value);
      billingInfo.value.middleName =
          StringHelper.getText(middleNameController.value);
      billingInfo.value.email = StringHelper.getText(emailController.value);
      billingInfo.value.phone = StringHelper.getText(phoneController.value);
      billingInfo.value.postCode =
          StringHelper.getText(postcodeController.value);
      billingInfo.value.address =
          StringHelper.getText(myAddressController.value);
      billingInfo.value.nameOnUtr =
          StringHelper.getText(nameOnUTRController.value);
      billingInfo.value.utrNumber = StringHelper.getText(utrController.value);
      billingInfo.value.ninNumber = StringHelper.getText(ninController.value);
      billingInfo.value.nameOnAccount =
          StringHelper.getText(nameOnAccountController.value);
      billingInfo.value.bankName =
          StringHelper.getText(bankNameController.value);
      billingInfo.value.accountNo = StringHelper.getText(accountNumberController.value);
      billingInfo.value.shortCode =
          StringHelper.getText(sortCodeController.value);

      if ((billingInfo.value.id ?? 0) != 0) {
        updateBillingInfoAPI();
      }
      else{
        addBillingInfoAPI();
      }
    }
  }
  bool valid() {
    return formKey.currentState!.validate();
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
    billingInfo.value.extension = extension;
  }
}
