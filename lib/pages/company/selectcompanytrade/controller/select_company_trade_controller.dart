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
import 'package:otm_inventory/pages/company/joincompany/controller/join_company_repository.dart';
import 'package:otm_inventory/pages/company/joincompany/model/get_companies_response.dart';
import 'package:otm_inventory/pages/company/joincompany/model/join_company_code_response.dart';
import 'package:otm_inventory/pages/company/joincompany/model/join_company_response.dart';
import 'package:otm_inventory/pages/company/selectcompanytrade/controller/select_company_trade_repository.dart';
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

class SelectCompanyTradeController extends GetxController
    implements SelectItemListener, DialogButtonClickListener {
  final selectTradeController = TextEditingController().obs;
  final _api = SelectCompanyTradeRepository();

  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final List<ModuleInfo> listTrades = <ModuleInfo>[].obs;
  final companyDetails = JoinCompanyCodeResponse().obs;
  final tradeId = 0.obs;
  final requestedCode = "".obs;
  final fromSignUp = false.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      companyDetails.value = arguments[AppConstants.intentKey.companyData];
      requestedCode.value = arguments[AppConstants.intentKey.companyCode] ?? "";
      fromSignUp.value =
          arguments[AppConstants.intentKey.fromSignUpScreen] ?? "";
      listTrades.addAll(companyDetails.value.trades!);
    }
  }

  onClickJoinCompany() {
    if (!StringHelper.isEmptyString(
        selectTradeController.value.text.toString().trim())) {
      if (fromSignUp.value) {
        joinCompany("", tradeId.value.toString(),
            (companyDetails.value.companyId ?? 0).toString());
      } else {
        joinCompany(requestedCode.value, tradeId.value.toString(), "0");
      }
    } else {
      AppUtils.showToastMessage('please_select_trade'.tr);
    }
  }

  void joinCompany(String code, String tradeId, String companyId) async {
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
            if (response.info != null) {
             /* UserInfo? user_permissions = AppStorage().getUserInfo();
              if (user_permissions != null &&
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

  void moveToDashboard() {
    Get.offAllNamed(AppRoutes.dashboardScreen);
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
    if (action == AppConstants.dialogIdentifier.selectTrade) {
      tradeId.value = id;
      selectTradeController.value.text = name;
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

  onValueChange() {
    // formKey.currentState!.validate();
  }

  void showSnackBar(String message) {
    AppUtils.showSnackBarMessage(message);
  }
}
