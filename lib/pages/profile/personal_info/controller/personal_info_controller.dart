import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/common/model/user_response.dart';
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
      isInternetNotAvailable = false.obs;
  final FocusNode focusNode = FocusNode();
  var arguments = Get.arguments;
  var isShowSaveButton = true.obs;

  final isSaveEnabled = false.obs;
  Map<String, dynamic> initialData = {};
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
    setInitData();
    setupListeners();
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
    //userCodeController.value.text = userInfo.value.co ?? "";

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
  }

  void verifyAction() {
    if (isOtpViewVisible.value){
      if (mOtpCode.value.length == 6) {
        onSubmitClick();
      }
    }
    else{

      if (emailController.value.text.isNotEmpty){
        if (AppUtils().isEmailValid(StringHelper.getText(emailController.value))){

        }
        else{

        }
      }
      else{

      }

      sendOtpApi();
      isOtpViewVisible.value = true;
    }
  }

  listenSmsCode() async {
    print("regiestered");
    await SmsAutoFill().listenForCode();
  }

  void sendOtpApi() async {
    Map<String, dynamic> map = {};
    UserInfo info = Get.find<AppStorage>().getUserInfo();
    map["phone"] = info.phone ?? "";
    map["extension"] = info.extension ?? "";
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

  void verifyOtpApi(String otp) async {
    Map<String, dynamic> map = {};
    UserInfo info = Get.find<AppStorage>().getUserInfo();
    map["phone"] = info.phone ?? "";
    map["extension"] = info.extension ?? "";
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
  void onSubmitClick() {
    if (isOtpViewVisible.value) {
      if (!isOtpVerified.value) {
        if (mOtpCode.value.length == 6) {
          verifyOtpApi(mOtpCode.value);
        } else {
          AppUtils.showSnackBarMessage('enter_otp'.tr);
        }
      }
      else{

      }
    }
    else{
      sendOtpApi();
    }
  }

  @override
  void onSelectPhoneExtension(int id, String extension, String flag,
      String country) {
    // TODO: implement onSelectPhoneExtension
    mFlag.value = flag;
    mExtension.value = extension;
    mExtensionId.value = id;
  }
}