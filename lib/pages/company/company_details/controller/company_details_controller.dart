import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/other_info_steps/step1_team_users_count_info/model/CompanyResourcesResponse.dart';
import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:belcka/pages/common/listener/select_date_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/listener/select_time_listener.dart';
import 'package:belcka/pages/common/phone_extension_list_dialog.dart';
import 'package:belcka/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:belcka/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:belcka/pages/company/company_details/controller/company_details_repository.dart';
import 'package:belcka/pages/company/company_details/model/company_details_response.dart';
import 'package:belcka/pages/company/company_signup/model/company_info.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/location_service_new.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';

class CompanyDetailsController extends GetxController
    implements
        SelectItemListener,
        SelectPhoneExtensionListener,
        SelectAttachmentListener,
        SelectDateListener,
        SelectTimeListener {
  final companyNameController = TextEditingController().obs;
  final companyCodeController = TextEditingController().obs;
  final companyAdminController = TextEditingController().obs;
  final companyAddressController = TextEditingController().obs;
  final companyEmailController = TextEditingController().obs;
  final companyWebsiteController = TextEditingController().obs;
  final companyDescriptionController = TextEditingController().obs;
  final registrationNumberController = TextEditingController().obs;
  final vatNumberController = TextEditingController().obs;
  final companyEstablishDateController = TextEditingController().obs;
  final mainContractsController = TextEditingController().obs;
  final workingHourController = TextEditingController().obs;
  final insuranceNumberController = TextEditingController().obs;
  final insuranceExpiresOnController = TextEditingController().obs;
  final numberOfEmployeeController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final focusNodePhone = FocusNode().obs;
  final focusNodeAddress = FocusNode().obs;
  final focusNodeMainContracts = FocusNode().obs;
  final focusNodeNumberOfEmployee = FocusNode().obs;
  final mExtension = AppConstants.defaultPhoneExtension.obs;
  final mExtensionId = AppConstants.defaultPhoneExtensionId.obs;
  final mFlag = AppConstants.defaultFlagUrl.obs;
  final formKey = GlobalKey<FormState>();
  final RxBool isMainViewVisible = false.obs,
      isLoading = false.obs,
      isInternetNotAvailable = false.obs;
  DateTime? establishedDate, insuranceExpiresOn;
  DateTime? workingHourTIme;
  final mCompanyLogo = "".obs;
  bool locationLoaded = false;
  final _api = CompanyDetailsRepository();
  Position? latLon = null;
  final locationService = LocationServiceNew();
  String? latitude, longitude, location;
  int companyAdminId = 0, companyId = 0;
  final listCompanyAdmins = <ModuleInfo>[].obs;
  CompanyInfo? companyInfo;

  @override
  void onInit() {
    super.onInit();
    // appLifeCycle();
    var arguments = Get.arguments;
    if (arguments != null) {
      companyId = arguments[AppConstants.intentKey.companyId] ?? 0;
    }
    if (companyId == 0) {
      companyId = ApiConstants.companyId;
    }
    /*var userInfo = AppStorage().getUserInfo();
    mExtensionId.value = userInfo.phoneExtensionId ?? 0;
    mExtension.value = userInfo.phoneExtension ?? "";*/

    getCompanyDetailsApi();
  }

  void setInitialData() {
    if (companyInfo != null) {
      companyNameController.value.text = companyInfo?.name ?? "";
      companyCodeController.value.text = companyInfo?.code ?? "";
      companyAdminId = companyInfo?.createdByInt ?? 0;
      companyAdminController.value.text = companyInfo?.createdBy ?? "";
      companyAddressController.value.text = companyInfo?.address ?? "";
      mExtension.value = companyInfo?.extension ?? "";
      mFlag.value = AppUtils.getFlagByExtension(companyInfo?.extension ?? "");
      phoneController.value.text = companyInfo?.phone ?? "";
      companyEmailController.value.text = companyInfo?.email ?? "";
      companyWebsiteController.value.text = companyInfo?.website ?? "";
      companyDescriptionController.value.text = companyInfo?.description ?? "";
      registrationNumberController.value.text =
          companyInfo?.registrationNumber ?? "";
      vatNumberController.value.text = companyInfo?.vatNumber ?? "";
      companyEstablishDateController.value.text =
          companyInfo?.establishedDate ?? "";
      mainContractsController.value.text = companyInfo?.mainContracts ?? "";
      workingHourController.value.text = companyInfo?.workingHour ?? "";
      insuranceNumberController.value.text = companyInfo?.insuranceNumber ?? "";
      insuranceExpiresOnController.value.text =
          companyInfo?.insuranceExpiresOn ?? "";
      numberOfEmployeeController.value.text = companyInfo?.totalTeamUsers ?? "";
      mCompanyLogo.value = companyInfo?.companyThumbImage ?? "";
    }
  }

  void getCompanyResourcesApi(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["flag"] = "adminList";
    map["company_id"] = companyId;
    _api.getCompanyResourcesApi(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          CompanyResourcesResponse response = CompanyResourcesResponse.fromJson(
              jsonDecode(responseModel.result!));
          listCompanyAdmins.value = response.info ?? [];
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void getCompanyDetailsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = companyId;
    _api.getCompanyDetailsApi(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          CompanyDetailsResponse response = CompanyDetailsResponse.fromJson(
              jsonDecode(responseModel.result!));
          companyInfo = response.info!;
          setInitialData();
          getCompanyResourcesApi(false);
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void editCompanyApi() async {
    Map<String, dynamic> map = {};
    map["id"] = companyId;
    map["created_by"] = companyAdminId;
    map["name"] = StringHelper.getText(companyNameController.value);
    map["code"] = StringHelper.getText(companyCodeController.value);
    map["address"] = StringHelper.getText(companyAddressController.value);
    map["phone"] = StringHelper.getPhoneNumberText(phoneController.value);
    map["extension"] = mExtension.value;
    map["email"] = StringHelper.getText(companyEmailController.value);
    map["website"] = StringHelper.getText(companyWebsiteController.value);
    map["description"] =
        StringHelper.getText(companyDescriptionController.value);
    map["registration_number"] =
        StringHelper.getText(registrationNumberController.value);
    map["vat_number"] = StringHelper.getText(vatNumberController.value);
    map["established_date"] =
        StringHelper.getText(companyEstablishDateController.value);
    map["main_contracts"] = StringHelper.getText(mainContractsController.value);
    map["working_hour"] = StringHelper.getText(workingHourController.value);
    map["insurance_number"] =
        StringHelper.getText(insuranceNumberController.value);
    map["insurance_expires_on"] =
        StringHelper.getText(insuranceExpiresOnController.value);
    map["total_team_users"] =
        StringHelper.getText(numberOfEmployeeController.value);
    map["device_type"] = AppConstants.deviceType;
    // map["device_name"] = AppUtils.getDeviceName();
    // map["latitude"] = "";
    // map["longitude"] = "";
    // map["address"] = "";
    multi.FormData formData = multi.FormData.fromMap(map);
    print("reques value:" + map.toString());
    print("mCompanyLogo.value:" + mCompanyLogo.value.toString());

    if (!StringHelper.isEmptyString(mCompanyLogo.value) &&
        !mCompanyLogo.startsWith("http")) {
      // final mimeType = lookupMimeType(file. path);
      formData.files.add(
        MapEntry("company_image",
            await multi.MultipartFile.fromFile(mCompanyLogo.value)),
      );
    }

    isLoading.value = true;
    _api.editCompanyApi(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          print("responseModel.isSuccess");
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
        }
      },
    );
  }

  onClickContinueButton() {
    if (valid()) {
      editCompanyApi();
    }
  }

  void moveToDashboard() {
    Get.offAllNamed(AppRoutes.dashboardScreen);
  }

  void showCompanyAdminList() {
    if (listCompanyAdmins.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.selectCompanyAdmin,
          'company_admin'.tr, listCompanyAdmins, this);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
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
    if (action == AppConstants.dialogIdentifier.selectCompanyAdmin) {
      companyAdminId = id;
      companyAdminController.value.text = name;
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
    // if (valid && StringHelper.isEmptyString(mCompanyLogo.value)) {
    //   valid = false;
    //   AppUtils.showSnackBarMessage('please_select_company_logo'.tr);
    // }
    return valid;
  }

  onValueChange() {
    // formKey.currentState!.validate();
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
  void onSelectAttachment(List<String> path, String action) {
    if (action == AppConstants.attachmentType.image) {
      ManageAttachmentController().cropCompanyLogo(path[0], this);
    } else if (action == AppConstants.attachmentType.croppedImage) {
      mCompanyLogo.value = path[0];
    }
  }

  void showDatePickerDialog(String dialogIdentifier, DateTime? date,
      DateTime firstDate, DateTime lastDate) {
    DateUtil.showDatePickerDialog(
        initialDate: date,
        firstDate: firstDate,
        lastDate: lastDate,
        dialogIdentifier: dialogIdentifier,
        selectDateListener: this);
  }

  void showTimePickerDialog(String dialogIdentifier, DateTime? time) {
    DateUtil.showTimePickerDialog(
        initialTime: time,
        dialogIdentifier: dialogIdentifier,
        selectTimeListener: this);
  }

  @override
  void onSelectDate(DateTime date, String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.establishedDate) {
      establishedDate = date;
      companyEstablishDateController.value.text =
          DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_DASH);
    } else if (dialogIdentifier ==
        AppConstants.dialogIdentifier.insuranceExpiryDate) {
      insuranceExpiresOn = date;
      insuranceExpiresOnController.value.text =
          DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_DASH);
    }
  }

  @override
  void onSelectTime(DateTime time, String dialogIdentifier) {
    if (dialogIdentifier ==
        AppConstants.dialogIdentifier.selectWorkingHourTime) {
      workingHourTIme = time;
      workingHourController.value.text =
          DateUtil.timeToString(time, DateUtil.HH_MM_24);
    }
  }

  @override
  void dispose() {
    focusNodePhone.value.dispose();
    super.dispose();
  }
}
