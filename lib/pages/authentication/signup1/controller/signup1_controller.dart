import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/login/models/RegisterResourcesResponse.dart';
import 'package:otm_inventory/pages/authentication/otp_verification/model/user_info.dart';
import 'package:otm_inventory/pages/authentication/signup1/controller/signup1_repository.dart';
import 'package:otm_inventory/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:otm_inventory/pages/common/phone_extension_list_dialog.dart';
import 'package:otm_inventory/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:otm_inventory/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class SignUp1Controller extends GetxController
    implements SelectPhoneExtensionListener, SelectAttachmentListener {
  final phoneController = TextEditingController().obs;
  final firstNameController = TextEditingController().obs;
  final lastNameController = TextEditingController().obs;
  final mExtension = AppConstants.defaultPhoneExtension.obs;
  final mExtensionId = AppConstants.defaultPhoneExtensionId.obs;
  final mFlag = AppConstants.defaultFlagUrl.obs;
  final isPhoneNumberExist = false.obs;
  final phoneNumberErrorMessage = "".obs;
  final formKey = GlobalKey<FormState>();
  final imagePath = "".obs;

  final _api = SignUp1Repository();

  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final registerResourcesResponse = RegisterResourcesResponse().obs;

  final otpController = TextEditingController().obs;
  final mOtpCode = "".obs;

  @override
  void onInit() {
    super.onInit();
    getRegisterResources();
  }

  void onSubmitClick() {
    if (valid()) {
      var userInfo = UserInfo();
      userInfo.firstName = StringHelper.getText(firstNameController.value);
      userInfo.lastName = StringHelper.getText(lastNameController.value);
      userInfo.phone = StringHelper.getText(phoneController.value);
      userInfo.phoneExtension = mExtension.value;
      userInfo.phoneExtensionId = mExtensionId.value;
      var arguments = {
        AppConstants.intentKey.userInfo: userInfo,
      };
      Get.toNamed(AppRoutes.signUp2Screen, arguments: arguments);
    }
    // update();
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
    return formKey.currentState!.validate();
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
    mExtensionId.value = id;
  }

  onValueChange() {
    // formKey.currentState!.validate();
  }

  showAttachmentOptionsDialog() async {
    print("pickImage");
    var listOptions = <ModuleInfo>[].obs;
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = 'camera'.tr;
    info.action = AppConstants.attachmentType.camera;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'gallery'.tr;
    info.action = AppConstants.attachmentType.image;
    listOptions.add(info);

    ManageAttachmentController().showAttachmentOptionsDialog(
        'select_photo_from_'.tr, listOptions, this);
  }

  @override
  void onSelectAttachment(String path, String action) {
    if (action == AppConstants.attachmentType.camera ||
        action == AppConstants.attachmentType.image) {
      ManageAttachmentController().cropImage(path, this);
    } else if (action == AppConstants.attachmentType.croppedImage) {
      print("cropped path:" + path);
      print("action:" + action);
      imagePath.value = path;
    }
  }

  void setRegisterResourcesResponse(RegisterResourcesResponse value) =>
      registerResourcesResponse.value = value;

  void showSnackBar(String message) {
    AppUtils.showSnackBarMessage(message);
  }
}
