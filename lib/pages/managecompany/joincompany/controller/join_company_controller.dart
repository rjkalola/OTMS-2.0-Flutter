import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/login/models/RegisterResourcesResponse.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/authentication/signup1/controller/signup1_repository.dart';
import 'package:otm_inventory/pages/common/drop_down_list_dialog.dart';
import 'package:otm_inventory/pages/common/listener/DialogButtonClickListener.dart';
import 'package:otm_inventory/pages/common/listener/SelectPhoneExtensionListener.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/phone_extension_list_dialog.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/controller/join_company_repository.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/model/get_companies_response.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/model/join_company_code_response.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/model/join_company_response.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/AlertDialogHelper.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class JoinCompanyController extends GetxController
    implements SelectItemListener, DialogButtonClickListener {
  final selectCompanyController = TextEditingController().obs;
  final addCompanyCodeController = TextEditingController().obs;
  final selectYourRoleController = TextEditingController().obs;
  final _api = JoinCompanyRepository();

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isOtpViewVisible = false.obs;
  final List<ModuleInfo> listCompanies = <ModuleInfo>[].obs;
  final companyId = 0.obs;
  final requestedCode = "".obs;
  final otpController = TextEditingController().obs;
  final mOtpCode = "".obs;

  @override
  void onInit() {
    super.onInit();
    // getCompaniesApi();
  }

  onClickSearch() {
    requestedCode.value = "";
    if (!StringHelper.isEmptyString(
        addCompanyCodeController.value.text.toString().trim())) {
      joinCompanyCode(
          "0", addCompanyCodeController.value.text.toString().trim());
    } else {
      showSnackBar('please_enter_company_code'.tr);
    }
  }

  Future<void> openQrCodeScanner() async {
    requestedCode.value = await Get.toNamed(AppRoutes.qrCodeScannerScreen);
    if (!StringHelper.isEmptyString(requestedCode.value)) {
      scanInviteCode(requestedCode.value);
    } else {
      AppUtils.showToastMessage('error_invalid_qr_code_via_id_card_scan'.tr);
    }
  }

  void joinCompanyCode(String id, String code) async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = id ?? "";
    map["code"] = code ?? "";
    multi.FormData formData = multi.FormData.fromMap(map);
    // isLoading.value = true;
    _api.joinCompanyCode(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          JoinCompanyCodeResponse response = JoinCompanyCodeResponse.fromJson(
              jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            if (!StringHelper.isEmptyList(response.trades)) {
              var arguments = {
                AppConstants.intentKey.companyData: response,
                AppConstants.intentKey.companyCode: requestedCode.value,
                AppConstants.intentKey.fromSignUpScreen: true,
              };
              Get.toNamed(AppRoutes.selectCompanyTradeScreen,
                  arguments: arguments);
            } else {
              joinCompanyRequest(0, response.companyId ?? 0);
            }
          } else {
            showSnackBar(response.message!);
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
  }

  void getCompaniesApi() {
    isLoading.value = true;
    _api.getCompanies(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          GetCompaniesResponse response =
              GetCompaniesResponse.fromJson(jsonDecode(responseModel.result!));
          if (!StringHelper.isEmptyList(response.info)) {
            listCompanies.addAll(response.info!);
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

  void scanInviteCode(String code) async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["code"] = code ?? "";
    multi.FormData formData = multi.FormData.fromMap(map);
    // isLoading.value = true;
    _api.scanInviteCode(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          JoinCompanyCodeResponse response = JoinCompanyCodeResponse.fromJson(
              jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            if (!StringHelper.isEmptyList(response.trades)) {
              var arguments = {
                AppConstants.intentKey.companyData: response,
                AppConstants.intentKey.companyCode: requestedCode.value,
                AppConstants.intentKey.fromSignUpScreen: true,
              };
              Get.toNamed(AppRoutes.selectCompanyTradeScreen,
                  arguments: arguments);
            } else {
              joinCompanyRequest(0, response.companyId ?? 0);
            }
          } else {
            showSnackBar(response.message!);
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
  }

  void joinCompanyApi(String code, int tradeId, int companyId) async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["trade_id"] = tradeId ?? "";
    map["code"] = code ?? "";
    map["company_id"] = companyId ?? "";
    multi.FormData formData = multi.FormData.fromMap(map);
    // isLoading.value = true;
    _api.joinCompany(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          JoinCompanyResponse response =
              JoinCompanyResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            if (response.Data != null) {
            /*  UserInfo? user = AppStorage().getUserInfo();
              if (user != null &&
                  !StringHelper.isEmptyString(
                      response.Data?.companyName ?? "")) {
                AppUtils.showToastMessage(
                    "Now, you are a member of ${response.Data?.companyName ?? ""}");
              }*/
            }
            moveToDashboard();
          } else {
            showSnackBar(response.message!);
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
  }

  void joinCompanyRequest(int tradeId, int companyId) {
    if (!StringHelper.isEmptyString(requestedCode.value)) {
      joinCompanyApi(requestedCode.value, tradeId, 0);
    } else {
      joinCompanyApi("", tradeId, companyId);
    }
  }

  void moveToDashboard() {
    Get.offAllNamed(AppRoutes.dashboardScreen);
  }

  void moveToCompanySignUp() {
    Get.offAllNamed(AppRoutes.companySignUpScreen);
  }

  void showCompanyListList() {
    requestedCode.value = "";
    if (listCompanies.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.selectCompany,
          'select_company'.tr, listCompanies, this);
    } else {
      AppUtils.showToastMessage('empty_company_list'.tr);
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
    if (action == AppConstants.dialogIdentifier.selectCompany) {
      companyId.value = id;
      showJoinCompanyDialog();
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
      joinCompanyCode(companyId.toString(), "");
      Get.back();
    }
  }

  onValueChange() {
    // formKey.currentState!.validate();
  }

  void showSnackBar(String message) {
    AppUtils.showSnackBarMessage(message);
  }
}
