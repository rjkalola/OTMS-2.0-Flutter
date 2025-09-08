import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/model/user_response.dart';
import 'package:belcka/pages/company/company_details/controller/company_details_repository.dart';
import 'package:belcka/pages/company/joincompany/controller/join_company_repository.dart';
import 'package:belcka/pages/company/joincompany/model/join_company_code_response.dart';
import 'package:belcka/pages/company/joincompany/model/join_company_response.dart';
import 'package:belcka/pages/company/joincompany/model/trade_list_response.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinCompanyController extends GetxController
    implements SelectItemListener, DialogButtonClickListener {
  final selectCompanyController = TextEditingController().obs;
  final addCompanyCodeController = TextEditingController().obs;
  final selectYourRoleController = TextEditingController().obs;
  final _api = JoinCompanyRepository();

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isOtpViewVisible = false.obs,
      isSelectTradeVisible = false.obs;
  final List<ModuleInfo> listCompanies = <ModuleInfo>[].obs;
  final List<ModuleInfo> listTrades = <ModuleInfo>[].obs;
  final companyId = 0.obs;
  final requestedCode = "".obs;
  final otpController = TextEditingController().obs;
  final mOtpCode = "".obs;
  int tradeId = 0;

  @override
  void onInit() {
    super.onInit();
    // getCompaniesApi();
    // getTradeDataApi();
  }

  onClickSearch() {
    requestedCode.value = "";
    if (!StringHelper.isEmptyString(
        addCompanyCodeController.value.text.toString().trim())) {
      joinCompanyCode(
          "0", addCompanyCodeController.value.text.toString().trim());
    } else {
      AppUtils.showApiResponseMessage('please_enter_company_code'.tr);
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
              // joinCompanyRequest(0, response.companyId ?? 0);
            }
          } else {
            AppUtils.showApiResponseMessage(response.message);
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage!);
        }
      },
    );
  }

  void getTradeDataApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["flag"] = "tradeList";
    map["company_id"] = ApiConstants.companyId;
    CompanyDetailsRepository().getCompanyResourcesApi(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          TradeListResponse response =
              TradeListResponse.fromJson(jsonDecode(responseModel.result!));
          if (!StringHelper.isEmptyList(response.info)) {
            listTrades.addAll(response.info!);
            isOtpViewVisible.value = false;
            isSelectTradeVisible.value = true;
          }
        } else {
          // AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // Utils.showApiResponseMessage('no_internet'.tr);
        }
        // else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showApiResponseMessage(error.statusMessage!);
        // }
      },
    );
  }

  void storeTradeApi() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["user_id"] = Get.find<AppStorage>().getUserInfo().id;
    map["company_id"] = ApiConstants.companyId;
    map["trade_id"] = tradeId;
    multi.FormData formData = multi.FormData.fromMap(map);
    // isLoading.value = true;
    _api.storeTradeApi(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          /* JoinCompanyResponse response =
              JoinCompanyResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.message ?? "");
          int companyId = response.info?.companyId ?? 0;
          print("companyId:" + companyId.toString());
          var userInfo = Get.find<AppStorage>().getUserInfo();
          userInfo.companyId = companyId;
          Get.find<AppStorage>().setUserInfo(userInfo);
          Get.find<AppStorage>().setCompanyId(companyId);
          ApiConstants.companyId = companyId;
          isOtpViewVisible.value = true;
          isSelectTradeVisible.value = true;*/

          // BaseResponse response =
          //     BaseResponse.fromJson(jsonDecode(responseModel.result!));
          // AppUtils.showApiResponseMessage(response.Message ?? "");
          // moveToDashboard();

          UserResponse response =
              UserResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.message ?? "");
          int companyId = response.info?.companyId ?? 0;
          Get.find<AppStorage>().setUserInfo(response.info!);
          Get.find<AppStorage>().setCompanyId(companyId);
          ApiConstants.companyId = companyId;
          AppUtils.saveLoginUser(response.info!);
          moveToDashboard();
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
        // else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        // }
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
              // joinCompanyRequest(0, response.companyId ?? 0);
            }
          } else {
            AppUtils.showApiResponseMessage(response.message!);
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage!);
        }
      },
    );
  }

  void joinCompanyApi() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["otp"] = mOtpCode.value;
    multi.FormData formData = multi.FormData.fromMap(map);
    // isLoading.value = true;
    _api.joinCompany(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          JoinCompanyResponse response =
              JoinCompanyResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.message ?? "");
          int companyId = response.info?.companyId ?? 0;
          print("companyId:" + companyId.toString());
          var userInfo = Get.find<AppStorage>().getUserInfo();
          userInfo.companyId = companyId;
          Get.find<AppStorage>().setUserInfo(userInfo);
          Get.find<AppStorage>().setCompanyId(companyId);
          ApiConstants.companyId = companyId;
          getTradeDataApi();
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
        // else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        // }
      },
    );
  }

  /* void joinCompanyRequest(int tradeId, int companyId) {
    if (!StringHelper.isEmptyString(requestedCode.value)) {
      joinCompanyApi(requestedCode.value, tradeId, 0);
    } else {
      joinCompanyApi("", tradeId, companyId);
    }
  }*/

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

  void showTradeList() {
    if (listTrades.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.selectTrade,
          'select_trade'.tr, listTrades, this);
    } else {
      AppUtils.showToastMessage('empty_trade_list'.tr);
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
    } else if (action == AppConstants.dialogIdentifier.selectTrade) {
      tradeId = id;
      selectYourRoleController.value.text = name;
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
      joinCompanyCode(companyId.toString(), "");
      Get.back();
    }
  }

  onValueChange() {
    // formKey.currentState!.validate();
  }
}
