import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/common/model/user_response.dart';
import 'package:belcka/pages/profile/my_profile_details/model/my_profile_info_response.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/pages/profile/personal_info//controller/personal_info_repository.dart';
import 'package:belcka/pages/common/phone_extension_list_dialog.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PersonalInfoController extends GetxController implements SelectPhoneExtensionListener {
  final firstNameController = TextEditingController().obs;
  final lastNameController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final userCodeController = TextEditingController().obs;

  final mExtension = AppConstants.defaultPhoneExtension.obs;
  final mExtensionId = AppConstants.defaultPhoneExtensionId.obs;
  final mFlag = AppConstants.defaultFlagUrl.obs;
  final isPhoneNumberExist = false.obs,
      isOtpViewVisible = false.obs,
      isOtpVerified = false.obs;
  final formKey = GlobalKey<FormState>();
  final _api = PersonalInfoRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final FocusNode focusNode = FocusNode();
  var arguments = Get.arguments;
  var isShowSaveButton = true.obs;

  final isSaveEnabled = false.obs;
  Map<String, dynamic> initialData = {};

  int? userId = UserUtils.getLoginUserId();
  final userInfo = UserUtils
      .getUserInfo()
      .obs;

  final phoneNumberErrorMessage = "".obs;
  final otpController = TextEditingController().obs;
  final mOtpCode = "".obs;
  final otmResendTimeRemaining = 30.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ??
          UserUtils.getLoginUserId();
    }

    if (!UserUtils.isLoginUser(userId)) {
      isShowSaveButton.value = false;
    }
    else{
      isShowSaveButton.value = true;
    }
    getProfileAPI();
  }
  void setupListeners() {
    List<TextEditingController> controllers = [
      firstNameController.value,
      lastNameController.value,
      emailController.value,
      phoneController.value,
      userCodeController.value,
    ];
    for (var c in controllers) {
      c.addListener(checkForChanges);
    }
    // extension listener
    ever(mExtension, (_) => checkForChanges());
  }

  void checkForChanges() {
    final currentData = {
      "firstName": firstNameController.value.text.trim(),
      "lastName": lastNameController.value.text.trim(),
      "email": emailController.value.text.trim(),
      "phone": phoneController.value.text.trim(),
      "userCode": userCodeController.value.text.trim(),
      "extension": mExtension.value,
    };
    isSaveEnabled.value = jsonEncode(initialData) != jsonEncode(currentData);
  }

  void setInitData() {
    firstNameController.value.text = userInfo.value.firstName ?? "";
    lastNameController.value.text = userInfo.value.lastName ?? "";
    emailController.value.text = userInfo.value.email ?? "";
    phoneController.value.text = userInfo.value.phone ?? "";
    userCodeController.value.text = userInfo.value.userCode ?? "";

    if (userInfo.value.extension != null) {
      mExtension.value = userInfo.value.extension ?? "";
    }

    mFlag.value = AppUtils.getFlagByExtension(mExtension.value);

    //Store initial values for comparison
    initialData = {
      "firstName": firstNameController.value.text,
      "lastName": lastNameController.value.text,
      "email": emailController.value.text,
      "phone": phoneController.value.text,
      "userCode": userCodeController.value.text,
      "extension": mExtension.value,
    };

    setupListeners();
  }
  bool valid() {
    bool valid = false;
    valid = formKey.currentState!.validate();
    return valid;
  }
  listenSmsCode() async {
    print("regiestered");
    await SmsAutoFill().listenForCode();
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

  void showPhoneExtensionDialog() {
    Get.bottomSheet(
        PhoneExtensionListDialog(
            title: 'select_country_code'.tr,
            list: DataUtils.getPhoneExtensionList(),
            listener: this),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }
  void submitAction() {
    if (valid()) {
      if (isOtpViewVisible.value){
        if (mOtpCode.value.length == 6) {
          onClickVerifyOTP();
        }
      }
      else{
        //check for phone change, then only call otp api, otherwise call update profile
        final oldPhoneNumber = "${userInfo.value.extension ?? ""}${userInfo.value.phone ?? ""}";
        final newPhoneNumber = "${mExtension.value}${StringHelper.getText(phoneController.value)}";
        print("oldPhoneNumber:${oldPhoneNumber}");
        print("newPhoneNumber:${newPhoneNumber}");
        print("isChanged? ${oldPhoneNumber != newPhoneNumber}");
        final isPhoneNumberChanged = oldPhoneNumber != newPhoneNumber;
        if (isPhoneNumberChanged){
          sendOtpApi();
        }
        else{
          updateProfileAPI();
        }
      }
    }
  }
  void onClickVerifyOTP() {
    if (isOtpViewVisible.value) {
      if (!isOtpVerified.value) {
        if (mOtpCode.value.length == 6) {
          verifyOtpApi(mOtpCode.value);
        }
        else{
          AppUtils.showSnackBarMessage('enter_otp'.tr);
        }
      }
    }
    else{
      sendOtpApi();
    }
  }
  //API Calls
  void checkPhoneNumberExist() async {
    String phoneNumber = StringHelper.getText(phoneController.value);
    if (!StringHelper.isEmptyString(phoneNumber)) {
      if (phoneNumber.length == 10) {
        Map<String, dynamic> map = {};
        map["extension"] = mExtension.value;
        map["phone"] = phoneNumber;
        multi.FormData formData = multi.FormData.fromMap(map);

        _api.checkPhoneNumberExist(
          data: map,
          onSuccess: (ResponseModel responseModel) {
            if (responseModel.statusCode == 200) {
              BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
              if (responseModel.isSuccess) {
                isPhoneNumberExist.value = true;
                phoneNumberErrorMessage.value = AppUtils.getStringTr(response.Message ?? "");

              } else {
                isPhoneNumberExist.value = false;
                phoneNumberErrorMessage.value = "";
              }
            } else {
              isPhoneNumberExist.value = false;
              phoneNumberErrorMessage.value = "";
            }
            isLoading.value = false;
          },
          onError: (ResponseModel error) {
            isPhoneNumberExist.value = false;
            phoneNumberErrorMessage.value = "";
            isLoading.value = false;
          },
        );
      } else {}
    } else {
      isPhoneNumberExist.value = false;
      phoneNumberErrorMessage.value = 'required_field'.tr;
    }
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
  void sendOtpApi() async {
    Map<String, dynamic> map = {};
    map["phone"] = StringHelper.getText(phoneController.value);
    map["extension"] = mExtension.value;
    multi.FormData formData = multi.FormData.fromMap(map);
    isLoading.value = true;
    _api.sendLoginOtpAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          listenSmsCode();
          isOtpViewVisible.value = true;
          startOtpTimeCounter();
          BaseResponse response =
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message!);
        }
        else {
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

  void verifyOtpApi(String otp) async {
    Map<String, dynamic> map = {};
    map["phone"] = StringHelper.getText(phoneController.value);
    map["extension"] = mExtension.value;
    map["otp"] = otp;

    isLoading.value = true;
    _api.verifyOtpUrl(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          updateProfileAPI();
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
        }
      },
    );
  }
  void updateProfileAPI() async {
    Map<String, dynamic> map = {};
    map["first_name"] = StringHelper.getText(firstNameController.value);
    map["last_name"] = StringHelper.getText(lastNameController.value);
    map["email"] = StringHelper.getText(emailController.value);
    map["phone"] = StringHelper.getText(phoneController.value);
    map["extension"] = mExtension.value;
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
            Get.find<AppStorage>().setUserInfo(response.info!);
            print("Token:" + ApiConstants.accessToken);
            AppUtils.saveLoginUser(response.info!);
            Get.offAllNamed(AppRoutes.dashboardScreen);
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

  @override
  void onSelectPhoneExtension(int id, String extension, String flag,
      String country) {
    // TODO: implement onSelectPhoneExtension
    mFlag.value = flag;
    mExtension.value = extension;
    mExtensionId.value = id;
    isPhoneNumberExist.value = false;
    phoneNumberErrorMessage.value = "";
  }
}