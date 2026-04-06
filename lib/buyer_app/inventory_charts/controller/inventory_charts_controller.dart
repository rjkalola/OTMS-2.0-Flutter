import 'dart:convert';

import 'package:belcka/buyer_app/inventory_charts/controller/inventory_charts_repository.dart';
import 'package:belcka/buyer_app/inventory_charts/model/inventory_charts_overview_response.dart';
import 'package:belcka/buyer_app/stores/store_list/controller/buyer_store_repository.dart';
import 'package:belcka/buyer_app/stores/store_list/models/store_list_response.dart';
import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum InventoryChartDisplayType { bar, line }

class InventoryChartsController extends GetxController
    implements DateFilterListener, SelectItemListener, MenuItemListener {
  final _overviewApi = InventoryChartsRepository();
  final _storesApi = BuyerStoreRepository();

  final RxBool isLoading = false.obs;
  final RxBool isInternetNotAvailable = false.obs;
  final RxBool isMainViewVisible = false.obs;

  final RxString startDate = "".obs;
  final RxString endDate = "".obs;
  final RxString displayStartDate = "".obs;
  final RxString displayEndDate = "".obs;
  final RxInt selectedDateFilterIndex = 2.obs;

  final RxInt storeId = 0.obs;
  final RxString selectedStoreLabel = "".obs;

  final Rx<InventoryChartDisplayType> chartDisplayType =
      InventoryChartDisplayType.bar.obs;

  final Rx<InventoryChartsOverviewResponse> overviewData =
      InventoryChartsOverviewResponse().obs;

  final List<ModuleInfo> listStoresForDialog = [];

  static const String _storeDialogAction = 'inventoryChartsSelectStore';

  @override
  void onInit() {
    super.onInit();
    selectedStoreLabel.value = 'all'.tr;
    final arguments = Get.arguments;
    if (arguments != null) {
      selectedDateFilterIndex.value =
          arguments[AppConstants.intentKey.index] ?? 2;
      startDate.value = arguments[AppConstants.intentKey.startDate] ?? "";
      endDate.value = arguments[AppConstants.intentKey.endDate] ?? "";
      displayStartDate.value = startDate.value;
      displayEndDate.value = endDate.value;
    }
    if (startDate.value.isEmpty || endDate.value.isEmpty) {
      final range = DateUtil.getDateWeekRange("Month");
      startDate.value =
          DateUtil.dateToString(range[0], DateUtil.DD_MM_YYYY_SLASH);
      endDate.value =
          DateUtil.dateToString(range[1], DateUtil.DD_MM_YYYY_SLASH);
      displayStartDate.value = startDate.value;
      displayEndDate.value = endDate.value;
      selectedDateFilterIndex.value = 2;
    }
    listStoresForDialog.add(ModuleInfo(id: 0, name: 'all'.tr));
    fetchStores();
    fetchOverview(true);
  }

  void fetchStores() {
    _storesApi.buyerStoresList(
      queryParameters: {"company_id": ApiConstants.companyId},
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          final response =
              StoreListResponse.fromJson(jsonDecode(responseModel.result!));
          listStoresForDialog.clear();
          listStoresForDialog.add(ModuleInfo(id: 0, name: 'all'.tr));
          for (final s in response.info ?? []) {
            if (s.id != null) {
              listStoresForDialog.add(ModuleInfo(id: s.id, name: s.name));
            }
          }
        }
      },
      onError: (_) {},
    );
  }

  void fetchOverview(bool showProgress) {
    isLoading.value = showProgress;
    final map = <String, dynamic>{
      "company_id": ApiConstants.companyId,
      "start_date": startDate.value,
      "end_date": endDate.value,
      "store_id": storeId.value,
    };
    _overviewApi.inventoryOverviewCharts(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          overviewData.value = InventoryChartsOverviewResponse.fromJson(
              jsonDecode(responseModel.result!));
          displayStartDate.value =
              overviewData.value.startDate ?? startDate.value;
          displayEndDate.value = overviewData.value.endDate ?? endDate.value;
        } else {
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

  void showSelectStoreDialog() {
    if (listStoresForDialog.isEmpty) {
      AppUtils.showToastMessage('empty_data_message'.tr);
      return;
    }
    Get.bottomSheet(
      DropDownListDialog(
        title: 'store'.tr,
        dialogType: _storeDialogAction,
        list: List<ModuleInfo>.from(listStoresForDialog),
        listener: this,
        isCloseEnable: true,
        isSearchEnable: true,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void showMenuItemsDialog(BuildContext context) {
    final listItems = <ModuleInfo>[
      ModuleInfo(
        name: 'bar_chart'.tr,
        action: AppConstants.action.inventoryChartBar,
      ),
      ModuleInfo(
        name: 'line_chart'.tr,
        action: AppConstants.action.inventoryChartLine,
      ),
    ];
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  @override
  void onSelectMenuItem(ModuleInfo info, String dialogType) {
    if (info.action == AppConstants.action.inventoryChartBar) {
      chartDisplayType.value = InventoryChartDisplayType.bar;
    } else if (info.action == AppConstants.action.inventoryChartLine) {
      chartDisplayType.value = InventoryChartDisplayType.line;
    }
  }

  @override
  void onSelectDateFilter(int filterIndex, String filter, String start,
      String endDateStr, String dialogIdentifier) {
    selectedDateFilterIndex.value = filterIndex;
    startDate.value = start;
    endDate.value = endDateStr;
    displayStartDate.value = start;
    displayEndDate.value = endDateStr;
    fetchOverview(true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == _storeDialogAction) {
      storeId.value = id;
      selectedStoreLabel.value = id == 0 ? 'all'.tr : (name);
      fetchOverview(true);
    }
  }
}
