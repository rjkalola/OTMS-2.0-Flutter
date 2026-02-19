import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/profile/billing_details_new/model/active_company_info_response.dart';
import 'package:belcka/pages/profile/billing_info/model/billing_ifo.dart';
import 'package:belcka/pages/profile/rates/controller/rates_repository.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
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
import 'package:path/path.dart';

import '../../../teams/join_team_to_company/model/trade_list_response.dart';

class RatesController extends GetxController implements SelectItemListener, DialogButtonClickListener{

  final tradeController = TextEditingController().obs;
  final joinCompanyDateController = TextEditingController().obs;
  final netPerDayController = TextEditingController().obs;

  final formKey = GlobalKey<FormState>();
  final _api = RatesRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs, isMainViewVisible = false.obs;
  final billingInfo = BillingInfo().obs;
  final FocusNode focusNode = FocusNode();
  var arguments = Get.arguments;
  String joiningDate = "";
  var grossPerDay = 0.0.obs;
  var cis = 0.0.obs;
  int? tradeId = 0;
  RxBool isRateRequested = false.obs;
  var isShowSaveButton = true.obs;
  final List<ModuleInfo> listTrades = <ModuleInfo>[].obs;

  RxBool isSaveEnabled = false.obs;
  String originalNetPerDay = "";
  int? originalTradeId;
  bool isDataChanged = false;

  @override
  void onInit() {
    super.onInit();
    if (arguments != null) {
      billingInfo.value = arguments[AppConstants.intentKey.billingInfo];
      billingInfo.value.userId = arguments[AppConstants.intentKey.userId];
    }
    billingInfo.value.companyId = ApiConstants.companyId;
    netPerDayController.value.addListener(calculateGrossAndCIS);
    getActiveCompanyInfo();
    getTradeDataApi();
  }
  double parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String && value.isNotEmpty) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
  void calculateGrossAndCIS(){
    var cisPercentage = (int.tryParse(billingInfo.value.cis ?? "") ?? 0) / 100;
    print("cisPercentage:$cisPercentage");

    var cisFinalValue = 0.20;
    if (cisPercentage > 0){
      cisFinalValue = cisPercentage;
    }

    if (isRateRequested.value){
      final net = double.tryParse(originalNetPerDay) ?? 0.00;
      cis.value = net * cisFinalValue;
      grossPerDay.value = net + cis.value;
    }
    else{
      final net = double.tryParse(netPerDayController.value.text ?? "") ?? 0.0;
      cis.value = net * cisFinalValue;
      grossPerDay.value = net + cis.value;
    }
    _checkForChanges();
  }
  bool isSameRate(double? oldRate, String newRateInput) {
    if (newRateInput.trim().isEmpty) return false;
    if (oldRate == null) return false;
    final newRate = double.tryParse(newRateInput);
    if (newRate == null) return false;
    // Prevent floating-point precision issues
    return (oldRate - newRate).abs() < 0.0001;
  }
  void _checkForChanges() {
    bool changed = false;
    final oldRate = double.tryParse(originalNetPerDay);
    final newRateInput = netPerDayController.value.text.trim();

    if (!isSameRate(oldRate, newRateInput) && (newRateInput.isNotEmpty)) {
      changed = true;
    }

    if (tradeId != originalTradeId) {
      changed = true;
    }
    isSaveEnabled.value = changed;
  }
  @override
  void onClose() {
    netPerDayController.value.dispose();
    super.onClose();
  }
  void getActiveCompanyInfo() async {
    Map<String, dynamic> map = {};
    map["user_id"] = billingInfo.value.userId;
    isLoading.value = true;
    _api.getActiveCompanyInfo(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          final response = ActiveCompanyInfoResponse.fromJson(jsonDecode(responseModel.result!));
          applyActiveCompanyData(response.info);
          isMainViewVisible.value = true;
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
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }
  void applyActiveCompanyData(ActiveCompanyInfo companyInfo) {
    final info = companyInfo;
    final bool isPending = info.isPendingRequest ?? false;
    isRateRequested.value = isPending;
    tradeId = info.tradeId;
    originalTradeId = info.tradeId;

    //Trade
    String tradeText = info.tradeName ?? "";
    if (isPending && info.diffData?.tradeName != null) {
      final oldTrade = info.diffData!.tradeName!.oldValue?.toString() ?? "";
      final newTrade = info.diffData!.tradeName!.newValue?.toString() ?? "";
      if (oldTrade.isNotEmpty && newTrade.isNotEmpty){
        tradeText = "$oldTrade > $newTrade";
      }
      else if (oldTrade.isNotEmpty){
        tradeText = oldTrade;
      }
    }
    tradeController.value.text = tradeText;

    // Rate
    String rateText = info.netRatePerDay != null ? "${info.netRatePerDay}" : "";
    originalNetPerDay = rateText;
    if (isPending && info.diffData?.netRatePerDay != null) {
      final oldRate = info.diffData!.netRatePerDay!.oldValue ?? 0.00;
      final newRate = info.diffData!.netRatePerDay!.newValue ?? 0.00;
      if (newRate > 0) {
        rateText = "${AppUtils.formatStringToDecimals(parseToDouble(oldRate))} > "
            "${AppUtils.formatStringToDecimals(parseToDouble(newRate))}";
        originalNetPerDay = "$newRate";
      }
      else if (oldRate > 0){
        rateText = AppUtils.formatStringToDecimals(parseToDouble(oldRate));
        originalNetPerDay = "$oldRate";
      }
    }

    netPerDayController.value.text = rateText;
    String joiningDateStr = companyInfo.joiningDate ?? "";
    joiningDate = joiningDateStr.split(" ").sublist(0, 3).join(" ");
    //calculate gross per day and cis %
    calculateGrossAndCIS();
  }
  void onSubmit() {
    bool isBothChanged = false;

    final oldRate = double.tryParse(originalNetPerDay);
    final newRateInput = netPerDayController.value.text.trim();
    if (!isSameRate(oldRate, newRateInput) && (tradeId != originalTradeId)) {
      isBothChanged = true;
    }

    if (isBothChanged){
      //both changed
      changeRateAndTradeAPI();
    }
    else{
      if (!isSameRate(oldRate, newRateInput)){
        //rate change api
        changeCompanyRateAPI();
      }
      if (tradeId != originalTradeId) {
        //call trade api
        changeTradeAPI();
      }
    }
  }
  void changeCompanyRateAPI() async {
    Map<String, dynamic> map = {};
    map["user_id"] = billingInfo.value.userId;
    map["company_id"] = ApiConstants.companyId;
    double netPerDay = double.parse(netPerDayController.value.text ?? "");
    double new_rate_perHour = netPerDay / 8;
    map["new_rate_perDay"] = netPerDay;
    map["new_rate_perHour"] = new_rate_perHour;

    isLoading.value = true;
    _api.changeCompanyRate(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          isDataChanged = true;
          getActiveCompanyInfo();
        }
        else{
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isShowSaveButton.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }
  void changeTradeAPI() async {
    Map<String, dynamic> map = {};
    map["user_id"] = billingInfo.value.userId;
    map["company_id"] = ApiConstants.companyId;
    map["trade_id"] = tradeId;

    isLoading.value = true;
    _api.changeTrade(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          isDataChanged = true;
          getActiveCompanyInfo();
        }
        else{
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isShowSaveButton.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }
  void changeRateAndTradeAPI() async {
    Map<String, dynamic> map = {};
    map["user_id"] = billingInfo.value.userId;
    map["company_id"] = ApiConstants.companyId;
    map["trade_id"] = tradeId;
    double netPerDay = double.parse(netPerDayController.value.text ?? "");
    map["new_rate_perDay"] = netPerDay;

    isLoading.value = true;
    _api.changeRateAndTrade(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          isDataChanged = true;
          getActiveCompanyInfo();
        }
        else{
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isShowSaveButton.value = true;
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
  showActionDialog(String dialogType) async {
    AlertDialogHelper.showAlertDialog(
        "",
        'would_you_like_to_change'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        dialogType);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectTrade) {
      tradeId = id;
      tradeController.value.text = name;
      _checkForChanges();
    }
  }
  void onBackPress() {
    Get.back(result: isDataChanged);
  }
  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {
    // TODO: implement onOtherButtonClicked
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    // TODO: implement onPositiveButtonClicked
    Get.back();
    isShowSaveButton.value = false;
    onSubmit();
  }
}
