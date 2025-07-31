import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/project/add_address/controller/add_address_repository.dart';
import 'package:otm_inventory/pages/project/address_details/model/address_details_info.dart';
import 'package:otm_inventory/pages/project/address_list/model/address_info.dart';
import 'package:otm_inventory/pages/project/project_info/model/project_info.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class AddAddressController extends GetxController{
  final siteAddressController = TextEditingController().obs;
  final formKey = GlobalKey<FormState>();
  final _api = AddAddressRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSaveEnable = false.obs;
  final title = ''.obs;

  ProjectInfo? projectInfo;
  AddressDetailsInfo? addressDetailsInfo;

  @override
  void onInit() {
    super.onInit();
    isMainViewVisible.value = true;
    var arguments = Get.arguments;
    if (arguments != null) {
      projectInfo = arguments[AppConstants.intentKey.projectInfo];
      addressDetailsInfo = arguments[AppConstants.intentKey.addressDetailsInfo];
    }
    if (addressDetailsInfo != null){
      title.value = 'Update Address';
      siteAddressController.value.text = addressDetailsInfo?.name ?? "";
    }
    else{
      title.value = 'Add Address';
    }
  }
  void addAddressApi() async {
    if (valid()) {
      Map<String, dynamic> map = {};
      map["project_id"] = projectInfo?.id ?? 0;
      map["name"] = StringHelper.getText(siteAddressController.value);

      isLoading.value = true;
      _api.addAddress(
        data: map,
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
  }

  void updateAddressApi() async {
    if (valid()) {
      Map<String, dynamic> map = {};
      map["id"] = addressDetailsInfo?.id ?? 0;
      map["project_id"] = addressDetailsInfo?.projectId ?? 0;
      map["name"] = StringHelper.getText(siteAddressController.value);
      isLoading.value = true;
      _api.updateAddress(
        data: map,
        onSuccess: (ResponseModel responseModel) {
          if (responseModel.isSuccess) {
            BaseResponse response =
                BaseResponse.fromJson(jsonDecode(responseModel.result!));
            AppUtils.showApiResponseMessage(response.Message ?? "");
            Get.back(result: true);
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
  void deleteAddressApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = projectInfo?.id ?? 0;
    _api.deleteAddress(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showApiResponseMessage('no_internet'.tr);
          // Utils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }
  bool valid() {
    return formKey.currentState!.validate();
  }
}
