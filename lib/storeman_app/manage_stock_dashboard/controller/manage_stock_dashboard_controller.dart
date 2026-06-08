import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/model/Dropdown_list_response.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/storeman_app/manage_stock_dashboard/controller/manage_stock_dashboard_repository.dart';
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

  // TODO: Replace stub with your count API response when you share it.
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
    // TODO: Plug your count API here.
    // The UI is already wired for store selection; when the API is ready,
    // update `allProductsCount`, `inStockCount`, `lowStockCount`,
    // and `outOfStockCount`.
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
    Get.toNamed(
      AppRoutes.stockProductsListScreen,
      arguments: {
        'store_id': selectedStoreId.value,
        'title': '${'all'.tr} ${'products'.tr}',
      },
    );
  }
}

