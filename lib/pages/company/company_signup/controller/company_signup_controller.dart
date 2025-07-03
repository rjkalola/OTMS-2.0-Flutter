import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/drop_down_list_dialog.dart';
import 'package:otm_inventory/pages/common/listener/DialogButtonClickListener.dart';
import 'package:otm_inventory/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/phone_extension_list_dialog.dart';
import 'package:otm_inventory/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:otm_inventory/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:otm_inventory/pages/company/company_signup/controller/company_signup_repository.dart';
import 'package:otm_inventory/pages/company/company_signup/model/company_registration_response.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/AlertDialogHelper.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/location_service_new.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class CompanySignUpController extends GetxController
    implements
        SelectItemListener,
        DialogButtonClickListener,
        SelectPhoneExtensionListener,
        SelectAttachmentListener {
  final companyNameController = TextEditingController().obs;
  final companyEmailController = TextEditingController().obs;
  final locationController = TextEditingController().obs;
  final currencyController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final focusNodePhone = FocusNode().obs;
  final mExtension = AppConstants.defaultPhoneExtension.obs;
  final mExtensionId = AppConstants.defaultPhoneExtensionId.obs;
  final mFlag = AppConstants.defaultFlagUrl.obs;
  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isOtpViewVisible = false.obs;
  final List<ModuleInfo> listCurrency = <ModuleInfo>[].obs;
  final fromSignUp = false.obs, isInitialResumeCall = false.obs;
  final mCompanyLogo = "".obs;
  final currencyId = 0.obs;
  bool locationLoaded = false;
  final _api = CompanySignUpRepository();
  Position? latLon = null;
  final locationService = LocationServiceNew();
  String? latitude, longitude, location;

  @override
  void onInit() {
    super.onInit();
    print("onInit");
    // appLifeCycle();
    var arguments = Get.arguments;
    if (arguments != null) {
      fromSignUp.value =
          arguments[AppConstants.intentKey.fromSignUpScreen] ?? "";
    }
    /*var userInfo = AppStorage().getUserInfo();
    mExtensionId.value = userInfo.phoneExtensionId ?? 0;
    mExtension.value = userInfo.phoneExtension ?? "";*/

    // getRegisterResources();
  }

  onClickJoinCompany() {
    // if (!StringHelper.isEmptyString(
    //     selectTradeController.value.text.toString().trim())) {
    //   if (fromSignUp.value) {
    //     joinCompany("", tradeId.value.toString(),
    //         (companyDetails.value.companyId ?? 0).toString());
    //   } else {
    //     joinCompany(requestedCode.value, tradeId.value.toString(), "0");
    //   }
    // } else {
    //   AppUtils.showToastMessage('please_select_trade'.tr);
    // }
  }

  void companyRegistration() async {
    Map<String, dynamic> map = {};
    map["created_by"] = Get.find<AppStorage>().getUserInfo().id;
    map["name"] = StringHelper.getText(companyNameController.value);
    map["email"] = StringHelper.getText(companyEmailController.value);
    map["phone"] = StringHelper.getText(phoneController.value);
    map["extension"] = mExtension.value;
    map["device_type"] = AppConstants.deviceType;
    // map["device_name"] = AppUtils.getDeviceName();
    // map["latitude"] = "";
    // map["longitude"] = "";
    // map["address"] = "";
    multi.FormData formData = multi.FormData.fromMap(map);
    print("reques value:" + map.toString());
    print("mCompanyLogo.value:" + mCompanyLogo.value.toString());

    if (!StringHelper.isEmptyString(mCompanyLogo.value)) {
      // final mimeType = lookupMimeType(file.path);
      formData.files.add(
        MapEntry("company_image",
            await multi.MultipartFile.fromFile(mCompanyLogo.value)),
      );
    }

    isLoading.value = true;
    _api.companyRegistrationApi(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          CompanyRegistrationResponse response =
              CompanyRegistrationResponse.fromJson(
                  jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.message ?? "");

          int companyId = response.info?.id ?? 0;
          print("companyId:" + companyId.toString());
          var userInfo = Get.find<AppStorage>().getUserInfo();
          userInfo.companyId = companyId;
          Get.find<AppStorage>().setUserInfo(userInfo);
          Get.find<AppStorage>().setCompanyId(companyId);
          ApiConstants.companyId = companyId;
          Get.offAllNamed(AppRoutes.teamUsersCountInfoScreen);

          // moveToDashboard();
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

  onClickContinueButton() {
    if (valid()) {
      companyRegistration();
    }
    // Get.toNamed(AppRoutes.teamUsersCountInfoScreen);
  }

  void moveToDashboard() {
    Get.offAllNamed(AppRoutes.dashboardScreen);
  }

  void showCurrencyList() {
    if (listCurrency.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.selectCurrency,
          'select_currency'.tr, listCurrency, this);
    } else {
      AppUtils.showToastMessage('empty_currency_list'.tr);
    }
  }

  void showDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        DropDownListDialog(
          title: title,
          dialogType: dialogType,
          list: list,
          listener: listener,
          isCloseEnable: true,
          isSearchEnable: true,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectCurrency) {
      currencyId.value = id;
      currencyController.value.text = name;
    }
  }

  showJoinCompanyDialog() async {
    AlertDialogHelper.showAlertDialog(
        "",
        'are_you_sure_you_want_to_join'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.joinCompany);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.joinCompany) {
      Get.back();
    }
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
    mExtensionId.value = id;
  }

  bool valid() {
    bool valid = false;
    valid = formKey.currentState!.validate();
    if (valid && StringHelper.isEmptyString(mCompanyLogo.value)) {
      valid = false;
      AppUtils.showSnackBarMessage('please_select_company_logo'.tr);
    }
    return valid;
  }

  onValueChange() {
    // formKey.currentState!.validate();
  }

  void showSnackBar(String message) {
    AppUtils.showSnackBarMessage(message);
  }

  Future<void> fetchLocationAndAddress() async {
    print("fetchLocationAndAddress");
    latLon = await LocationServiceNew.getCurrentLocation();
    if (latLon != null) {
      latitude = latLon!.latitude.toString();
      longitude = latLon!.longitude.toString();
      location = await LocationServiceNew.getAddressFromCoordinates(
          latLon!.latitude, latLon!.longitude);
      print("Location:" +
          "Latitude: ${latLon!.latitude}, Longitude: ${latLon!.longitude}");
      print("Address:${location ?? ""}");
    } else {
      print("Location:" + "Location permission denied or services disabled");
      print("Address:" + "Could not retrieve address");
    }
  }

  void appLifeCycle() {
    AppLifecycleListener(
      onResume: () async {
        print("onResume out in");
        if (!locationLoaded) locationRequest();
      },
    );
  }

  Future<void> locationRequest() async {
    locationLoaded = await locationService.checkLocationService();
    if (locationLoaded) {
      fetchLocationAndAddress();
    }
  }

  void onSelectCompanyLogo() {
    ManageAttachmentController().setListener(this);
    ManageAttachmentController()
        .selectImage(AppConstants.attachmentType.image, this);
  }

  @override
  void onSelectAttachment(String path, String action) {
    print("onSelectAttachment");
    if (action == AppConstants.attachmentType.image) {
      ManageAttachmentController().cropCompanyLogo(path, this);
    } else if (action == AppConstants.attachmentType.croppedImage) {
      print("cropped path:" + path);
      print("action:" + action);
      mCompanyLogo.value = path;
      print("File Size:" + getFileSizeString(bytes: File(path).lengthSync()));
    }
  }

  static String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  @override
  void dispose() {
    focusNodePhone.value.dispose();
    super.dispose();
  }
}
