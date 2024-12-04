import 'dart:convert';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_filter/controller/stock_filter_repository.dart';
import 'package:otm_inventory/pages/stock_filter/model/filter_info.dart';
import 'package:otm_inventory/pages/stock_filter/model/filter_request.dart';
import 'package:otm_inventory/pages/stock_filter/model/stock_filter_response.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';

import '../../../utils/app_storage.dart';
import '../../../web_services/response/response_model.dart';

class StockFilterController extends GetxController {
  final _api = StockFilterRepository();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isAllVisible = false.obs;

  var supplierList = <FilterInfo>[].obs;
  var categoriesList = <FilterInfo>[].obs;
  var selectedSupplierIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

   /* if (AppStorage().getStockFiltersData() != null) {
      StockFilterResponse response = AppStorage().getStockFiltersData()!;
      if (response.info != null && response.info!.isNotEmpty) {
        supplierList.addAll(response.info!);
        if (supplierList.isNotEmpty) {
          categoriesList.value = supplierList[0].data!;
        }
      }
      setAllButtonVisibility();
      isMainViewVisible.value = true;
    }*/

  }

  void onSelectSupplier(int index) {
    selectedSupplierIndex.value = index;
    setAllButtonVisibility();
    categoriesList.value = supplierList[index].data!;
    for (int j = 0; j < categoriesList.length; j++) {
      FilterInfo categoryInfo = categoriesList[j];
      print(categoryInfo.name);
    }
    categoriesList.refresh();
  }

  void setAllButtonVisibility() {
    if (supplierList[selectedSupplierIndex.value].key == 'all_category') {
      isAllVisible.value = false;
    } else {
      isAllVisible.value = true;
    }
    print("isAllVisible:" + isAllVisible.value.toString());
  }

  void onSelectCategory(index) {
    categoriesList[index].check = !(categoriesList[index].check ?? false);
    supplierList[selectedSupplierIndex.value].data![index].check =
        categoriesList[index].check;
    categoriesList.refresh();
    print("Check:" + categoriesList[index].check!.toString());
    applyFilter();
  }

  void applyFilter_(int categoryId, String categoryName, String categoryKey) {
    FilterInfo supplierInfo = supplierList[selectedSupplierIndex.value];
    FilterRequest request = FilterRequest();
    request.supplier =
        supplierInfo.id != null ? supplierInfo.id!.toString() : "";
    request.supplier_key = supplierInfo.key ?? "";
    request.category = categoryId.toString();
    request.category_name = categoryName;
    request.category_key = categoryKey;

    // Get.back(result: request);
    print(jsonEncode(request));
    Get.back(result: jsonEncode(request));
  }

  void applyFilter() {
    var list = <FilterRequest>[];
    for (int i = 0; i < supplierList.length; i++) {
      FilterRequest request = FilterRequest();
      FilterInfo supplierInfo = supplierList[i];
      var listCategoryIds = <String>[];
      for (int j = 0; j < supplierInfo.data!.length; j++) {
        FilterInfo categoryInfo = supplierInfo.data![j];
        if (categoryInfo.check ?? false) {
          listCategoryIds.add(categoryInfo.id!.toString());
        }
        // print(categoryInfo.name);
      }
      if (listCategoryIds.isNotEmpty) {
        request.supplier =
            supplierInfo.id != null ? supplierInfo.id!.toString() : "";
        request.category =
            StringHelper.getCommaSeparatedStringIds(listCategoryIds);
        request.supplier_key = supplierInfo.key ?? "";
        list.add(request);
      }
    }
    // print(jsonEncode(list));
    Get.back(result: jsonEncode(list));
  }

  /* List<FilterInfo> filterList() {
    var suppliers = <FilterInfo>[];

    FilterInfo? supplierInfo, categoryInfo;

    supplierInfo = FilterInfo();
    supplierInfo.id = 1;
    supplierInfo.name = "Supplier 1";

    var categories = <FilterInfo>[];

    categoryInfo = FilterInfo();
    categoryInfo.id = 1;
    categoryInfo.name = "Category 1";
    categories.add(categoryInfo);

    categoryInfo = FilterInfo();
    categoryInfo.id = 2;
    categoryInfo.name = "Category 2";
    categories.add(categoryInfo);

    categoryInfo = FilterInfo();
    categoryInfo.id = 3;
    categoryInfo.name = "Category 3";
    categories.add(categoryInfo);

    supplierInfo.data = categories;
    suppliers.add(supplierInfo);

    supplierInfo = FilterInfo();
    supplierInfo.id = 2;
    supplierInfo.name = "Supplier 2";

    var categories2 = <FilterInfo>[];

    categoryInfo = FilterInfo();
    categoryInfo.id = 5;
    categoryInfo.name = "Category 5";
    categories2.add(categoryInfo);

    categoryInfo = FilterInfo();
    categoryInfo.id = 6;
    categoryInfo.name = "Category 6";
    categories2.add(categoryInfo);

    categoryInfo = FilterInfo();
    categoryInfo.id = 7;
    categoryInfo.name = "Category 7";
    categories2.add(categoryInfo);

    supplierInfo.data = categories2;

    suppliers.add(supplierInfo);

    return suppliers;
  }*/

  void getFiltersListApi() async {
    Map<String, dynamic> map = {};
    multi.FormData formData = multi.FormData.fromMap(map);
    isLoading.value = true;
    _api.getStockFiltersList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          StockFilterResponse response =
              StockFilterResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            isMainViewVisible.value = true;
            if (response.info != null && response.info!.isNotEmpty) {
              supplierList.addAll(response.info!);
              if (supplierList.isNotEmpty) {
                categoriesList.value = supplierList[0].data!;
              }
            }
          } else {
            AppUtils.showSnackBarMessage(response.message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isMainViewVisible.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }
}
