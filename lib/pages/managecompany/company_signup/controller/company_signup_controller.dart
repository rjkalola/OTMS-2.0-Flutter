import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otm_inventory/pages/authentication/login/models/RegisterResourcesResponse.dart';
import 'package:otm_inventory/pages/authentication/signup1/controller/signup1_repository.dart';
import 'package:otm_inventory/pages/common/drop_down_list_dialog.dart';
import 'package:otm_inventory/pages/common/listener/DialogButtonClickListener.dart';
import 'package:otm_inventory/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/phone_extension_list_dialog.dart';
import 'package:otm_inventory/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:otm_inventory/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/controller/company_signup_repository.dart';
import 'package:otm_inventory/routes/app_pages.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/AlertDialogHelper.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/location_service.dart';
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
  final mExtension = AppConstants.defaultPhoneExtension.obs;
  final mExtensionId = AppConstants.defaultPhoneExtensionId.obs;
  final mFlag = AppConstants.defaultFlagUrl.obs;
  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isOtpViewVisible = false.obs;
  final List<ModuleInfo> listCurrency = <ModuleInfo>[].obs;
  final fromSignUp = false.obs, isInitialResumeCall = false.obs;
  final registerResourcesResponse = RegisterResourcesResponse().obs;
  final mCompanyLogo = "".obs, mOtpCode = "".obs;
  final currencyId = 0.obs;
  bool locationLoaded = false;
  final _api = CompanySignUpRepository();
  Position? latLon = null;
  final locationService = LocationServiceNew();
  String? latitude, longitude, location;
  final otpController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    print("onInit");
    appLifeCycle();
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

  onClickContinueButton() {
    // controller.valid();
    Get.toNamed(AppRoutes.teamUsersCountInfoScreen);
  }

  void getRegisterResources() {
    isLoading.value = true;
    SignUp1Repository().getRegisterResources(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          // fetchLocationAndAddress();
          locationRequest();
          setRegisterResourcesResponse(RegisterResourcesResponse.fromJson(
              jsonDecode(responseModel.result!)));
          listCurrency.addAll(registerResourcesResponse.value.currency ?? []);
          if (mExtensionId.value != 0 &&
              !StringHelper.isEmptyList(
                  registerResourcesResponse.value.countries)) {
            for (var info in registerResourcesResponse.value.countries!) {
              if (info.id! == mExtensionId.value) {
                mFlag.value = info.flagImage!;
                break;
              }
            }
          }
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

  // void joinCompany(String code, String tradeId, String companyId) async {
  //   isLoading.value = true;
  //   Map<String, dynamic> map = {};
  //   map["trade_id"] = tradeId ?? "";
  //   map["code"] = code ?? "";
  //   map["company_id"] = companyId ?? "";
  //
  //   multi.FormData formData = multi.FormData.fromMap(map);
  //   // isLoading.value = true;
  //   _api.joinCompany(
  //     formData: formData,
  //     onSuccess: (ResponseModel responseModel) {
  //       if (responseModel.statusCode == 200) {
  //         JoinCompanyResponse response =
  //             JoinCompanyResponse.fromJson(jsonDecode(responseModel.result!));
  //         if (response.isSuccess!) {
  //           if (response.Data != null) {
  //             UserInfo? user = AppStorage().getUserInfo();
  //             if (user != null &&
  //                 !StringHelper.isEmptyString(
  //                     response.Data?.companyName ?? "")) {
  //               AppUtils.showToastMessage(
  //                   "Now, you are a member of ${response.Data?.companyName ?? ""}");
  //             }
  //           }
  //           moveToDashboard();
  //         } else {
  //           showSnackBar(response.message!);
  //         }
  //       } else {
  //         showSnackBar(responseModel.statusMessage!);
  //       }
  //       isLoading.value = false;
  //     },
  //     onError: (ResponseModel error) {
  //       isLoading.value = false;
  //       if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
  //         showSnackBar('no_internet'.tr);
  //       } else if (error.statusMessage!.isNotEmpty) {
  //         showSnackBar(error.statusMessage!);
  //       }
  //     },
  //   );
  // }

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

  bool valid() {
    return formKey.currentState!.validate();
  }

  void setRegisterResourcesResponse(RegisterResourcesResponse value) =>
      registerResourcesResponse.value = value;

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
    }
  }
}
