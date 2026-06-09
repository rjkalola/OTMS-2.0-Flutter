import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/model/Dropdown_list_response.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/storeman_app/manage_stock_dashboard/controller/manage_stock_dashboard_repository.dart';
import 'package:belcka/storeman_app/manage_stock_dashboard/model/manage_stock_modules_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageStockDashboardController extends GetxController
    implements SelectItemListener {
  final _api = ManageStockDashboardRepository();

  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  RxBool isMainViewVisible = false.obs;

  final listStores = <ModuleInfo>[].obs;
  final selectedStoreId = 0.obs;
  final selectedStoreTitle = "".obs;

  final RxInt allProductsCount = 0.obs;
  final RxInt inStockCount = 0.obs;
  final RxInt lowStockCount = 0.obs;
  final RxInt outOfStockCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getStoresApi();
  }

  void getStoresApi() {
    isLoading.value = true;
    isInternetNotAvailable.value = false;

    final Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;

    _api.getStores(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          final DropdownListResponse response =
              DropdownListResponse.fromJson(
            jsonDecode(responseModel.result!),
          );

          listStores.clear();
          listStores.addAll(response.info ?? []);

          if (listStores.isNotEmpty) {
            selectedStoreId.value = listStores.first.id ?? 0;
            selectedStoreTitle.value = listStores.first.name ?? "";
          } else {
            selectedStoreId.value = 0;
            selectedStoreTitle.value = "";
          }

          fetchCountsForSelectedStore();
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }

        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage?.isNotEmpty ?? false) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void fetchCountsForSelectedStore() {
    if (selectedStoreId.value <= 0) {
      _resetCounts();
      return;
    }

    final Map<String, dynamic> map = {};
    map['company_id'] = ApiConstants.companyId;
    map['store_id'] = selectedStoreId.value;
    map['is_web'] = true;

    _api.getModules(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          final response = ManageStockModulesResponse.fromJson(
            jsonDecode(responseModel.result!) as Map<String, dynamic>,
          );
          allProductsCount.value = response.totalProducts ?? 0;
          inStockCount.value = response.inStockCount ?? 0;
          lowStockCount.value = response.lowStockCount ?? 0;
          outOfStockCount.value = response.outOfStockCount ?? 0;
        } else {
          _resetCounts();
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? '');
        }
      },
      onError: (ResponseModel error) {
        _resetCounts();
        if (error.statusMessage?.isNotEmpty ?? false) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? '');
        }
      },
    );
  }

  void _resetCounts() {
    allProductsCount.value = 0;
    inStockCount.value = 0;
    lowStockCount.value = 0;
    outOfStockCount.value = 0;
  }

  void showStoresDialog() {
    if (listStores.isEmpty) {
      AppUtils.showToastMessage('empty_data_message'.tr);
      return;
    }

    Get.bottomSheet(
      DropDownListDialog(
        title: 'store'.tr,
        dialogType: AppConstants.action.selectStoreDialog,
        list: listStores,
        listener: this,
        isCloseEnable: true,
        isSearchEnable: true,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.action.selectStoreDialog) {
      selectedStoreId.value = id;
      selectedStoreTitle.value = name;
      fetchCountsForSelectedStore();
    }
  }

  void onAllProductsClick() {
    _openStockProductsList(
      title: '${'all'.tr} ${'products'.tr}',
    );
  }

  void onInStockClick() {
    _openStockProductsList(
      title: 'in_stock'.tr,
      stockStatus: AppConstants.productStockStatus.inStock,
    );
  }

  void onLowStockClick() {
    _openStockProductsList(
      title: 'low_stock'.tr,
      stockStatus: AppConstants.productStockStatus.lowStock,
    );
  }

  void onOutOfStockClick() {
    _openStockProductsList(
      title: 'out_of_stock'.tr,
      stockStatus: AppConstants.productStockStatus.outOfStock,
    );
  }

  void _openStockProductsList({
    required String title,
    int stockStatus = 0,
  }) async {
    final arguments = <String, dynamic>{
      'store_id': selectedStoreId.value,
      'title': title,
    };
    if (stockStatus > 0) {
      arguments['stock_status'] = stockStatus;
    }
    final result = await Get.toNamed(
      AppRoutes.stockProductsListScreen,
      arguments: arguments,
    );
    if (result == true) {
      fetchCountsForSelectedStore();
    }
  }
}

