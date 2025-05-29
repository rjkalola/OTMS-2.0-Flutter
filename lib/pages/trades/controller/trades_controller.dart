import 'dart:convert';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_filter/controller/stock_filter_repository.dart';
import 'package:otm_inventory/pages/stock_filter/model/filter_info.dart';
import 'package:otm_inventory/pages/stock_filter/model/filter_request.dart';
import 'package:otm_inventory/pages/stock_filter/model/stock_filter_response.dart';
import 'package:otm_inventory/pages/trades/controller/trades_repository.dart';
import 'package:otm_inventory/pages/trades/model/company_trades_response.dart';
import 'package:otm_inventory/pages/trades/model/trade_info.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';

import '../../../utils/app_storage.dart';
import '../../../web_services/response/response_model.dart';

class TradesController extends GetxController {
  final _api = TradesRepository();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
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

  void changeCompanyTradeStatusApi(int tradeId, bool status) async {
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["trade_id"] = tradeId;
    map["status"] = status ? 1 : 0;

    // isLoading.value = true;
    _api.changeCompanyTradeStatus(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          // BaseResponse response =
          //     BaseResponse.fromJson(jsonDecode(responseModel.result!));
          // AppUtils.showApiResponseMessage(response.Message ?? "");
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
}
