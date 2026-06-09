import 'dart:convert';

import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/storeman_app/stock_history/controller/stock_history_repository.dart';
import 'package:belcka/storeman_app/stock_history/model/stock_history_response.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

enum StockHistoryTab { all, stockIn, stockOut }

class StockHistoryController extends GetxController
    implements DialogButtonClickListener {
  final _api = StockHistoryRepository();

  final isLoading = false.obs;
  final isInternetNotAvailable = false.obs;
  final isMainViewVisible = false.obs;
  final selectedDateFilterIndex = 1.obs;
  final selectedTab = StockHistoryTab.all.obs;
  final totalCount = 0.obs;

  final allItems = <StockHistoryInfo>[].obs;
  final filteredItems = <StockHistoryInfo>[].obs;

  String startDate = '';
  String endDate = '';

  @override
  void onInit() {
    super.onInit();
    getStockHistory(true);
  }

  void getStockHistory(bool showProgress) {
    isLoading.value = showProgress;
    isInternetNotAvailable.value = false;

    final map = <String, dynamic>{};
    map['company_id'] = ApiConstants.companyId;
    map['start_date'] = startDate;
    map['end_date'] = endDate;

    _api.getStockHistory(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          final response = StockHistoryResponse.fromJson(
            jsonDecode(responseModel.result!) as Map<String, dynamic>,
          );
          allItems.value = response.info ?? [];
          totalCount.value = response.total ?? allItems.length;
          _applyTabFilter();
          isMainViewVisible.value = true;
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? '');
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if ((error.statusMessage ?? '').isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? '');
        }
      },
    );
  }

  void onTabChanged(StockHistoryTab tab) {
    selectedTab.value = tab;
    _applyTabFilter();
  }

  void _applyTabFilter() {
    switch (selectedTab.value) {
      case StockHistoryTab.stockIn:
        filteredItems.value =
            allItems.where((item) => item.isInMovement).toList();
        break;
      case StockHistoryTab.stockOut:
        filteredItems.value =
            allItems.where((item) => item.isOutMovement).toList();
        break;
      case StockHistoryTab.all:
        filteredItems.value = List.from(allItems);
        break;
    }
  }

  void showNoteDialog(String note) {
    AlertDialogHelper.showAlertDialog(
      '${'note'.tr}:',
      note,
      'ok'.tr.toUpperCase(),
      '',
      '',
      true,
      false,
      this,
      AppConstants.dialogIdentifier.noteDialog,
    );
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.noteDialog) {
      Get.back();
    }
  }
}
