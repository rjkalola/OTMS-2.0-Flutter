import 'dart:convert';
import 'package:belcka/pages/add_trades/controller/add_trades_repository.dart';
import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/profile/billing_info/model/billing_ifo.dart';
import 'package:belcka/pages/trades/model/company_trades_response.dart';
import 'package:belcka/pages/trades/model/trade_info.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTradesController extends GetxController implements SelectItemListener, DialogButtonClickListener{

  final tradeNameController = TextEditingController().obs;
  final categoryController = TextEditingController().obs;

  final formKey = GlobalKey<FormState>();
  final _api = AddTradesRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final FocusNode focusNode = FocusNode();
  var arguments = Get.arguments;
  final companyTradesList = <TradeInfo>[].obs;
  final List<ModuleInfo> listTrades = <ModuleInfo>[].obs;
  int categoryId = 0;

  @override
  void onInit() {
    super.onInit();
    getCompanyTradesApi();
  }
  void onSubmit() {
    createTradeAPI();
  }
  void getCompanyTradesApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.getCompanyTradesApi(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          CompanyTradesResponse response =
          CompanyTradesResponse.fromJson(jsonDecode(responseModel.result!));
          companyTradesList.clear();
          companyTradesList.addAll(response.companyTrades ?? []);
          listTrades.addAll(
            companyTradesList.map(
                  (trade) => ModuleInfo(
                id: trade.id,
                name: trade.name,
              ),
            ),
          );
        }
        else{
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }
  void createTradeAPI() async {
    Map<String, dynamic> map = {};
    map["trade_category_id"] = categoryId;
    map["company_id"] = ApiConstants.companyId;
    map["name"] = tradeNameController.value.text ?? "";

    isLoading.value = true;
    _api.createTrade(
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
  void showTradeList() {

    if (companyTradesList.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.selectCategory,
          'select_category'.tr, listTrades, this);
    } else {
      AppUtils.showToastMessage('empty_category_list'.tr);
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
    if (action == AppConstants.dialogIdentifier.selectCategory) {
      categoryId = id;
      categoryController.value.text = name;
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
