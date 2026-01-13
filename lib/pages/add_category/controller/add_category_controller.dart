import 'dart:convert';
import 'package:belcka/pages/add_category/controller/add_category_repository.dart';
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

class AddCategoryController extends GetxController{

  final categoryController = TextEditingController().obs;
  RxBool isSaveEnabled = false.obs;
  RxBool isShowSaveButton = true.obs;
  final formKey = GlobalKey<FormState>();
  final _api = AddCategoryRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final FocusNode focusNode = FocusNode();
  var arguments = Get.arguments;
  final companyTradesList = <TradeInfo>[].obs;
  final List<ModuleInfo> listTrades = <ModuleInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    categoryController.value.addListener(checkForChanges);
  }
  void checkForChanges() {
    bool changed = false;
    final categoryName = categoryController.value.text.trim();
    if ((categoryName.isNotEmpty)) {
      changed = true;
    }
    isSaveEnabled.value = changed;
  }
  void onSubmit() {
    isShowSaveButton.value = false;
    createCategoryAPI();
  }
  void createCategoryAPI() async {
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["name"] = categoryController.value.text ?? "";

    isLoading.value = true;
    _api.createCategory(
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
}
