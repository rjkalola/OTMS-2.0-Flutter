import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/signup1/controller/signup1_repository.dart';
import 'package:otm_inventory/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:otm_inventory/pages/common/model/user_response.dart';
import 'package:otm_inventory/pages/common/phone_extension_list_dialog.dart';
import 'package:otm_inventory/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:otm_inventory/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SignUp1Controller extends GetxController
    implements SelectPhoneExtensionListener, SelectAttachmentListener {
  final phoneController = TextEditingController().obs;
  final firstNameController = TextEditingController().obs;
  final lastNameController = TextEditingController().obs;
  final focusNodePhone = FocusNode().obs;
  final mExtension = AppConstants.defaultPhoneExtension.obs;
  final mExtensionId = AppConstants.defaultPhoneExtensionId.obs;
  final mFlag = AppConstants.defaultFlagUrl.obs;
  final isPhoneNumberExist = false.obs,
      isOtpViewVisible = false.obs,
      isOtpVerified = false.obs;
  final phoneNumberErrorMessage = "".obs;
  final formKey = GlobalKey<FormState>();
  final imagePath = "".obs;

  final _api = SignUp1Repository();

  final RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;

  final otpController = TextEditingController().obs;
  final mOtpCode = "".obs;
  final otmResendTimeRemaining = 30.obs;
  Timer? _timer;

  listenSmsCode() async {
    print("regiestered");
    await SmsAutoFill().listenForCode();
  }

  @override
  void onInit() {
    super.onInit();
    // getRegisterResources();
  }

  void onSubmitClick() {
    if (isOtpViewVisible.value) {
      if (!isOtpVerified.value) {
        if (mOtpCode.value.length == 6) {
          verifyOtpApi(mOtpCode.value, mExtension.value,
              phoneController.value.text.toString().trim());
        } else {
          AppUtils.showSnackBarMessage('enter_otp'.tr);
        }
      } else {
        signUp();
      }
    } else {
      if (valid()) {
        sendOtpApi(
            mExtension.value, phoneController.value.text.toString().trim());
      }
    }

    /* if (valid()) {
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
    }*/
  }

  void checkPhoneNumberExist() async {
    String phoneNumber = StringHelper.getText(phoneController.value);
    if (!StringHelper.isEmptyString(phoneNumber)) {
      if (phoneNumber.length == 10) {
        Map<String, dynamic> map = {};
        map["extension"] = mExtension.value;
        map["phone"] = phoneNumber;
        multi.FormData formData = multi.FormData.fromMap(map);
        // isLoading.value = true;
        _api.checkPhoneNumberExist(
          data: map,
          onSuccess: (ResponseModel responseModel) {
            if (responseModel.statusCode == 200) {
              BaseResponse response =
                  BaseResponse.fromJson(jsonDecode(responseModel.result!));
              if (responseModel.isSuccess) {
                isPhoneNumberExist.value = true;
                phoneNumberErrorMessage.value =
                    AppUtils.getStringTr(response.Message ?? "");
                // var arguments = {
                //   AppConstants.intentKey.phoneExtension: extension,
                //   AppConstants.intentKey.phoneNumber: phoneNumber,
                // };
                // Get.toNamed(AppRoutes.verifyOtpScreen, arguments: arguments);

                // showSnackBar(response.message!);
              } else {
                isPhoneNumberExist.value = false;
                phoneNumberErrorMessage.value = "";
                // print("Message::::" +
                //     AppUtils.getStringTr(response.Message ?? ""));
                // showSnackBar(response.message!);
              }
            } else {
              isPhoneNumberExist.value = false;
              phoneNumberErrorMessage.value = "";
              // AppUtils.showApiResponseMessage(responseModel.statusMessage!);
            }
            isLoading.value = false;
          },
          onError: (ResponseModel error) {
            isPhoneNumberExist.value = false;
            phoneNumberErrorMessage.value = "";
            isLoading.value = false;
            /* if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
              AppUtils.showApiResponseMessage('no_internet'.tr);
            } else if (error.statusMessage!.isNotEmpty) {
              AppUtils.showApiResponseMessage(error.statusMessage!);
            }*/
          },
        );
      } else {}
    } else {
      isPhoneNumberExist.value = false;
      phoneNumberErrorMessage.value = 'required_field'.tr;
    }
  }

  void sendOtpApi(String extension, String phoneNumber) async {
    Map<String, dynamic> map = {};
    map["phone"] = phoneNumber;
    map["extension"] = extension;
    multi.FormData formData = multi.FormData.fromMap(map);
    isLoading.value = true;
    _api.sendOtpAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isOtpViewVisible.value = true;
          listenSmsCode();
          startOtpTimeCounter();
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message!);
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

  void verifyOtpApi(String otp, String extension, String phoneNumber) async {
    Map<String, dynamic> map = {};
    map["phone"] = phoneNumber;
    map["extension"] = extension;
    map["otp"] = otp;
    // multi.FormData formData = multi.FormData.fromMap(map);
    isLoading.value = true;
    _api.verifyOtpUrl(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isOtpVerified.value = true;
          // BaseResponse response =
          //     BaseResponse.fromJson(jsonDecode(responseModel.result!));
          // AppUtils.showApiResponseMessage(response.Message!);
          signUp();
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

  void signUp() async {
    Map<String, dynamic> map = {};
    map["first_name"] = StringHelper.getText(firstNameController.value);
    map["last_name"] = StringHelper.getText(lastNameController.value);
    map["extension"] = mExtension.value;
    map["phone"] = StringHelper.getText(phoneController.value);
    map["device_type"] = AppConstants.deviceType;
    // map["device_name"] = AppUtils.getDeviceName();
    // map["latitude"] = "";
    // map["longitude"] = "";
    // map["address"] = "";

    multi.FormData formData = multi.FormData.fromMap(map);
    print("reques value:" + map.toString());
    print("imagePath.value:" + imagePath.value.toString());

    if (!StringHelper.isEmptyString(imagePath.value)) {
      // final mimeType = lookupMimeType(file.path);
      formData.files.add(
        MapEntry(
            "user_image", await multi.MultipartFile.fromFile(imagePath.value)),
      );
    }

    isLoading.value = true;
    _api.register(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          UserResponse response =
              UserResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.message ?? "");
          Get.find<AppStorage>().setUserInfo(response.info!);
          Get.find<AppStorage>().setAccessToken(response.info!.apiToken ?? "");
          ApiConstants.accessToken = response.info!.apiToken ?? "";
          print("Token:" + ApiConstants.accessToken);
          AppUtils.saveLoginUser(response.info!);
          Get.offAllNamed(AppRoutes.joinCompanyScreen);
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
    bool valid = false;
    valid = formKey.currentState!.validate();
    if (valid && StringHelper.isEmptyString(imagePath.value)) {
      valid = false;
      AppUtils.showSnackBarMessage('please_select_image'.tr);
    }
    return valid;
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
    // mExtension.value = "+12345678";
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
  void onSelectAttachment(List<String> path, String action) {
    if (action == AppConstants.attachmentType.camera ||
        action == AppConstants.attachmentType.image) {
      ManageAttachmentController().cropImage(path[0], this);
    } else if (action == AppConstants.attachmentType.croppedImage) {
      print("cropped path:" + path[0]);
      print("action:" + action);
      imagePath.value = path[0];
    }
  }

  void startOtpTimeCounter() {
    otmResendTimeRemaining.value = 30;
    stopOtpTimeCounter(); // Cancel previous timer if exists
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (otmResendTimeRemaining.value == 0) {
        timer.cancel();
      } else {
        otmResendTimeRemaining.value--;
      }
    });
  }

  void stopOtpTimeCounter() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    stopOtpTimeCounter(); // Clean up
    SmsAutoFill().unregisterListener();
    focusNodePhone.value.dispose();
    super.dispose();
  }
}
