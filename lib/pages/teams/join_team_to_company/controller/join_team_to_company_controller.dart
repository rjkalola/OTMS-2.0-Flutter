import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/drop_down_list_dialog.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/company/joincompany/controller/join_company_repository.dart';
import 'package:otm_inventory/pages/company/joincompany/model/join_company_response.dart';
import 'package:otm_inventory/pages/company/joincompany/model/trade_list_response.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class JoinTeamToCompanyController extends GetxController
    implements SelectItemListener {
  final addCompanyCodeController = TextEditingController().obs;
  final selectYourRoleController = TextEditingController().obs;
  final _api = JoinCompanyRepository();

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isOtpViewVisible = false.obs,
      isSelectTradeVisible = false.obs;
  final List<ModuleInfo> listTrades = <ModuleInfo>[].obs;
  final otpController = TextEditingController().obs;
  final mOtpCode = "".obs;
  int tradeId = 0;

  @override
  void onInit() {
    super.onInit();
    // getCompaniesApi();
    // getTradeDataApi();
  }

  void getTradeDataApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["flag"] = "tradeList";
    map["company_id"] = ApiConstants.companyId;
    _api.getTradeListApi(
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

          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
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
      tradeId = id;
      selectYourRoleController.value.text = name;
    }
  }

  onValueChange() {
    // formKey.currentState!.validate();
  }
}
