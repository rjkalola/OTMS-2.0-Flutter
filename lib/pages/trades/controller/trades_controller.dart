import 'dart:convert';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/trades/controller/trades_repository.dart';
import 'package:belcka/pages/trades/model/company_trades_response.dart';
import 'package:belcka/pages/trades/model/save_trade_request.dart';
import 'package:belcka/pages/trades/model/trade_info.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';

import '../../../web_services/response/response_model.dart';

class TradesController extends GetxController
    implements MenuItemListener, DialogButtonClickListener {
  final _api = TradesRepository();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isDataUpdated = false.obs,
      isCheckAll = false.obs;
  final companyTradesList = <TradeInfo>[].obs;
  var isDeleteOptionEnabled = false.obs, hasSelection = false.obs;

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

  void deleteCompanyBulkTradeStatusApi() async {
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["trade_ids"] = getSelectedTradeIds();

    isLoading.value = true;
    _api.deleteCompanyBulkTrades(
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

  String getSelectedTradeIds() {
    List<int> selectedIds = [];
    if (companyTradesList.isNotEmpty) {
      for (var info in companyTradesList) {
        for (var tradeInfo in info.trades!) {
          if (tradeInfo.status == true) {
            selectedIds.add(tradeInfo.id!);
          }
        }
      }
    }
    return selectedIds.join(",");
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

  void checkDeleteButton() {
    bool isShowDelete = false;
    for (var info in companyTradesList) {
      for (var data in info.trades!) {
        if ((data.status ?? false) == true) {
          isShowDelete = true;
          break;
        }
      }
      if (isShowDelete) break;
    }
    hasSelection.value = isShowDelete;
  }

  void checkAll() {
    isDataUpdated.value = true;
    isCheckAll.value = true;
    hasSelection.value = true;
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
    hasSelection.value = false;
    for (var info in companyTradesList) {
      for (var data in info.trades!) {
        data.status = false;
      }
    }
    companyTradesList.refresh();
  }

  void onBackPress() {
    if (isDeleteOptionEnabled.value == true) {
      Get.back();
    } else {
      if (isDataUpdated.value) {
        changeCompanyBulkTradeStatusApi();
      } else {
        Get.back();
      }
    }
  }

  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    listItems.add(ModuleInfo(
        name: 'add_category'.tr, action: AppConstants.action.categories));
    listItems
        .add(ModuleInfo(name: 'add_trade'.tr, action: AppConstants.action.add));
    listItems
        .add(ModuleInfo(name: 'delete'.tr, action: AppConstants.action.delete));
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated.value = true;
      getCompanyTradesApi();
    }
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    // TODO: implement onNegativeButtonClicked
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {
    // TODO: implement onOtherButtonClicked
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    // TODO: implement onPositiveButtonClicked
  }

  @override
  void onSelectMenuItem(ModuleInfo info, String dialogType) {
    // TODO: implement onSelectMenuItem
    if (info.action == AppConstants.action.add) {
      var arguments = {
        //AppConstants.intentKey.projectInfo: projectInfo,
      };
      moveToScreen(AppRoutes.addTradesScreen, arguments);
    } else if (info.action == AppConstants.action.categories) {
      var arguments = {};
      moveToScreen(AppRoutes.addCategoryScreen, arguments);
    } else if (info.action == AppConstants.action.delete) {
      isDeleteOptionEnabled.value = true;
      unCheckAll();
      companyTradesList.refresh();
    }
  }
}
