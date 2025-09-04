import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/profile/billing_info/model/billing_ifo.dart';
import 'package:belcka/pages/profile/rates/controller/rates_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../teams/join_team_to_company/model/trade_list_response.dart';

class RatesController extends GetxController implements SelectItemListener, DialogButtonClickListener{

  final tradeController = TextEditingController().obs;
  final joinCompanyDateController = TextEditingController().obs;
  final netPerDayController = TextEditingController().obs;

  final formKey = GlobalKey<FormState>();
  final _api = RatesRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final billingInfo = BillingInfo().obs;
  final FocusNode focusNode = FocusNode();
  var arguments = Get.arguments;
  String joiningDate = "";
  var grossPerDay = 0.0.obs;
  var cis = 0.0.obs;
  int? tradeId = 0;
  
  final List<ModuleInfo> listTrades = <ModuleInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (arguments != null) {
      billingInfo.value = arguments[AppConstants.intentKey.billingInfo];
      setInitData();
    }
    billingInfo.value.userId = UserUtils.getLoginUserId();
    billingInfo.value.companyId = ApiConstants.companyId;
    netPerDayController.value.addListener(calculateGrossAndCIS);

    getTradeDataApi();
  }
  void setInitData() {
    tradeId = billingInfo.value.tradeId;
    netPerDayController.value.text = "${billingInfo.value.net_rate_perDay ?? 0}";
    tradeController.value.text = billingInfo.value.tradeName ?? "";
    String joiningDateStr = billingInfo.value.joiningDate ?? "";
    joiningDate = joiningDateStr.split(" ").sublist(0, 3).join(" ");
    //calculate gross per day and cis 20%
    calculateGrossAndCIS();
  }
  void calculateGrossAndCIS(){
    final net = double.tryParse(netPerDayController.value.text ?? "") ?? 0.0;
    cis.value = net * 0.20;
    grossPerDay.value = net + cis.value;
  }

  @override
  void onClose() {
    netPerDayController.value.dispose();
    super.onClose();
  }
  void onSubmit() {
    changeCompanyRateAPI();
  }
  void changeCompanyRateAPI() async {
    Map<String, dynamic> map = {};
    map["user_id"] = UserUtils.getLoginUserId();
    map["company_id"] = ApiConstants.companyId;
    map["trade_id"] = tradeId;
    double netPerDay = double.parse(netPerDayController.value.text ?? "");
    map["new_rate_perDay"] = netPerDay;
    isLoading.value = true;
    _api.changeCompanyRate(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
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
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }
  bool valid() {
    return formKey.currentState!.validate();
  }
  void getTradeDataApi() {
    Map<String, dynamic> map = {};
    map["flag"] = "tradeList";
    map["company_id"] = ApiConstants.companyId;
    _api.getCompanyResourcesApi(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {

        if (responseModel.isSuccess) {
          TradeListResponse response =
          TradeListResponse.fromJson(jsonDecode(responseModel.result!));
          if (!StringHelper.isEmptyList(response.info)) {
            listTrades.addAll(response.info!);
          }
        } else {
        }

        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        }
      },
    );
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
      tradeController.value.text = name;
    }
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    // TODO: implement onNegativeButtonClicked
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {
    // TODO: implement onOtherButtonClicked
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    // TODO: implement onPositiveButtonClicked
  }
}
