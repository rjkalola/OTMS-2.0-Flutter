import 'dart:convert';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/stock_filter/controller/stock_filter_repository.dart';
import 'package:belcka/pages/stock_filter/model/filter_info.dart';
import 'package:belcka/pages/stock_filter/model/filter_request.dart';
import 'package:belcka/pages/stock_filter/model/stock_filter_response.dart';
import 'package:belcka/pages/trades/controller/trades_repository.dart';
import 'package:belcka/pages/trades/model/company_trades_response.dart';
import 'package:belcka/pages/trades/model/save_trade_request.dart';
import 'package:belcka/pages/trades/model/trade_info.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';

import '../../../utils/app_storage.dart';
import '../../../web_services/response/response_model.dart';

class TradesController extends GetxController {
  final _api = TradesRepository();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isDataUpdated = false.obs,
      isCheckAll = false.obs;
  final companyTradesList = <TradeInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCompanyTradesApi();
  }

  void getCompanyTradesApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.getCompanyTradesApi(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          CompanyTradesResponse response =
              CompanyTradesResponse.fromJson(jsonDecode(responseModel.result!));
          companyTradesList.clear();
          companyTradesList.addAll(response.companyTrades ?? []);
          checkSelectAll();
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

  void changeCompanyBulkTradeStatusApi() async {
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    // map["trade_id"] = tradeId;
    // map["status"] = status ? 1 : 0;
    map["trades"] = getRequestData();

    isLoading.value = true;
    _api.changeCompanyBulkTradeStatus(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          Get.back(result: true);
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
        } else {
          // AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          // AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  List<SaveTradeRequest> getRequestData() {
    List<SaveTradeRequest> list = [];
    if (companyTradesList.isNotEmpty) {
      for (var info in companyTradesList) {
        for (var tradeInfo in info.trades!) {
          list.add(SaveTradeRequest(
              tradeId: tradeInfo.id,
              status: (tradeInfo.status ?? false) ? 1 : 0));
        }
      }
    }
    return list;
  }

  void checkSelectAll() {
    bool isAllSelected = true;
    for (var info in companyTradesList) {
      for (var data in info.trades!) {
        if ((data.status ?? false) == false) {
          isAllSelected = false;
          break;
        }
      }
      if (!isAllSelected) break;
    }
    isCheckAll.value = isAllSelected;
  }

  void checkAll() {
    isDataUpdated.value = true;
    isCheckAll.value = true;
    for (var info in companyTradesList) {
      for (var data in info.trades!) {
        data.status = true;
      }
    }
    companyTradesList.refresh();
  }

  void unCheckAll() {
    isDataUpdated.value = true;
    isCheckAll.value = false;
    for (var info in companyTradesList) {
      for (var data in info.trades!) {
        data.status = false;
      }
    }
    companyTradesList.refresh();
  }

  void onBackPress() {
    if (isDataUpdated.value) {
      changeCompanyBulkTradeStatusApi();
    } else {
      Get.back();
    }
  }
}
