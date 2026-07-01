import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/get_products_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/storeman_app/stock_products_list/controller/stock_products_list_repository.dart';
import 'package:belcka/storeman_app/stock_products_list/model/inventory_resources_response.dart';
import 'package:belcka/storeman_app/stock_products_list/view/widgets/stock_products_list_filter_sheet.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockProductsListController extends GetxController
    implements SelectItemListener {
  final _api = StockProductsListRepository();

  RxBool isLoading = false.obs,
      isLoadingMore = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isFilterResourcesLoading = false.obs;

  final productsList = <ProductInfo>[].obs;
  List<ProductInfo> tempList = [];
  final searchController = TextEditingController().obs;
  final supplierController = TextEditingController().obs;
  final categoryController = TextEditingController().obs;

  final supplierList = <ModuleInfo>[].obs;
  final categoryList = <ModuleInfo>[].obs;

  int storeId = 0;
  int stockStatus = 0;
  String screenTitle = '';
  int _tempSupplierId = 0;
  int _tempCategoryId = 0;
  int _appliedSupplierId = 0;
  int _appliedCategoryId = 0;
  bool _isFilterResourcesLoaded = false;

  final RxInt totalItems = 0.obs;

  final ScrollController scrollController = ScrollController();
  String _searchQuery = '';
  bool _hasStockUpdated = false;
  Timer? _debounce;

  var currentPage = 1.obs;
  int limit = 20;
  var hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      storeId = arguments['store_id'] ?? 0;
      stockStatus = arguments['stock_status'] ?? 0;
      screenTitle = arguments['title'] ?? 'stocks'.tr;
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!isLoading.value && !isLoadingMore.value && hasMoreData.value) {
          fetchProducts(showLoading: false);
        }
      }
    });

    fetchProducts(isRefresh: true);
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.value.dispose();
    supplierController.value.dispose();
    categoryController.value.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void fetchProducts({bool isRefresh = false, bool showLoading = true}) {
    if (isRefresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
      tempList.clear();
      productsList.clear();
      productsList.refresh();
    }
    if (!hasMoreData.value && !isRefresh) return;

    if (currentPage.value == 1) {
      if (showLoading) isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    isInternetNotAvailable.value = false;

    final Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["store_ids"] = storeId;
    map["is_products"] = true;
    map["is_web"] = true;
    map["page"] = currentPage.value;
    map["limit"] = limit;
    map["search"] = _searchQuery;
    if (stockStatus > 0) {
      map["stock_status"] = stockStatus;
    }
    if (_appliedCategoryId > 0) {
      map["category_ids"] = _appliedCategoryId;
    }
    if (_appliedSupplierId > 0) {
      map["supplier_id"] = _appliedSupplierId;
    }

    _api.getProducts(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        isLoadingMore.value = false;

        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          final jsonMap =
              jsonDecode(responseModel.result!) as Map<String, dynamic>;
          final GetProductsResponse response =
              GetProductsResponse.fromJson(jsonMap);

          if (response.pagination != null) {
            final newItems = response.info ?? [];

            if (isRefresh) {
              tempList.clear();
              currentPage.value = 1;
            }

            tempList.addAll(newItems);
            productsList.value = List.from(tempList);
            productsList.refresh();

            totalItems.value = response.pagination!.totalItems ?? 0;

            final totalPages = response.pagination!.totalPages ?? 1;
            final apiCurrentPage = response.pagination!.currentPage ?? 1;
            if (apiCurrentPage >= totalPages) {
              hasMoreData.value = false;
            } else {
              hasMoreData.value = true;
              currentPage.value++;
            }
          } else {
            tempList.clear();
            tempList.addAll(response.info ?? []);
            productsList.value = List.from(tempList);
            productsList.refresh();
            totalItems.value = tempList.length;
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isLoadingMore.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage?.isNotEmpty ?? false) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void fetchInventoryResources({VoidCallback? onLoaded}) {
    if (_isFilterResourcesLoaded) {
      onLoaded?.call();
      return;
    }

    isFilterResourcesLoading.value = true;

    final map = <String, dynamic>{};
    map['company_id'] = ApiConstants.companyId;

    _api.getInventoryResources(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        isFilterResourcesLoading.value = false;
        if (responseModel.isSuccess) {
          final response = InventoryResourcesResponse.fromJson(
            jsonDecode(responseModel.result!) as Map<String, dynamic>,
          );

          supplierList
            ..clear()
            ..add(ModuleInfo(id: 0, name: 'all'.tr))
            ..addAll(
              (response.suppliers ?? [])
                  .where((item) => !StringHelper.isEmptyString(item.name))
                  .map((item) => ModuleInfo(id: item.id ?? 0, name: item.name!)),
            );

          categoryList
            ..clear()
            ..add(ModuleInfo(id: 0, name: 'all'.tr))
            ..addAll(
              (response.categories ?? [])
                  .where((item) => !StringHelper.isEmptyString(item.name))
                  .map((item) => ModuleInfo(id: item.id ?? 0, name: item.name!)),
            );

          _isFilterResourcesLoaded = true;
          onLoaded?.call();
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
      },
      onError: (ResponseModel error) {
        isFilterResourcesLoading.value = false;
        if (error.statusMessage?.isNotEmpty ?? false) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void showFilterBottomSheet() {
    _tempSupplierId = _appliedSupplierId;
    _tempCategoryId = _appliedCategoryId;
    _syncFilterControllerText();

    fetchInventoryResources(onLoaded: () {
      Get.bottomSheet(
        StockProductsListFilterSheet(controller: this),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
      );
    });
  }

  void showSupplierFilterDialog() {
    if (supplierList.isEmpty) {
      AppUtils.showToastMessage('empty_data_message'.tr);
      return;
    }
    _showDropDownDialog(
      AppConstants.action.selectSupplierDialog,
      'suppliers'.tr,
      supplierList,
    );
  }

  void showCategoryFilterDialog() {
    if (categoryList.isEmpty) {
      AppUtils.showToastMessage('empty_data_message'.tr);
      return;
    }
    _showDropDownDialog(
      AppConstants.action.selectCategoryDialog,
      'category'.tr,
      categoryList,
    );
  }

  void _showDropDownDialog(
    String dialogType,
    String title,
    List<ModuleInfo> list,
  ) {
    Get.bottomSheet(
      DropDownListDialog(
        title: title,
        dialogType: dialogType,
        list: list,
        listener: this,
        isCloseEnable: true,
        isSearchEnable: true,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void applyFilters() {
    _appliedSupplierId = _tempSupplierId;
    _appliedCategoryId = _tempCategoryId;
    Get.back();
    fetchProducts(isRefresh: true);
  }

  void clearFilters() {
    _tempSupplierId = 0;
    _tempCategoryId = 0;
    _appliedSupplierId = 0;
    _appliedCategoryId = 0;
    _syncFilterControllerText();
    Get.back();
    fetchProducts(isRefresh: true);
  }

  void searchItem(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = value.trim();
      fetchProducts(isRefresh: true);
    });
  }

  void _syncFilterControllerText() {
    supplierController.value.text = _nameForId(
      supplierList,
      _tempSupplierId,
      fallback: 'all'.tr,
    );
    categoryController.value.text = _nameForId(
      categoryList,
      _tempCategoryId,
      fallback: 'all'.tr,
    );
  }

  String _nameForId(
    List<ModuleInfo> list,
    int id, {
    required String fallback,
  }) {
    if (id == 0) return fallback;
    for (final item in list) {
      if (item.id == id) {
        return item.name ?? fallback;
      }
    }
    return fallback;
  }

  void clearSearch() {
    _debounce?.cancel();
    searchController.value.clear();
    _searchQuery = '';
    isSearchEnable.value = false;
    fetchProducts(isRefresh: true);
  }

  String get appBarTitle {
    if (isLoading.value || !isMainViewVisible.value) {
      return screenTitle;
    }
    return '$screenTitle (${totalItems.value})';
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.action.selectSupplierDialog) {
      _tempSupplierId = id;
      supplierController.value.text = name;
      supplierController.refresh();
    } else if (action == AppConstants.action.selectCategoryDialog) {
      _tempCategoryId = id;
      categoryController.value.text = name;
      categoryController.refresh();
    }
  }

  Future<void> onProductItemClick(ProductInfo item) async {
    final result = await Get.toNamed(
      AppRoutes.editStockScreen,
      arguments: {
        'product': item,
        'store_id': storeId,
      },
    );
    if (result == true) {
      _hasStockUpdated = true;
      fetchProducts(isRefresh: true);
    }
  }

  void onBackPress() {
    Get.back(result: _hasStockUpdated ? true : null);
  }
}
