import 'dart:convert';
import 'package:belcka/pages/filter/model/filter_info.dart';
import 'package:belcka/pages/filter/model/filters_list_response.dart';
import 'package:belcka/pages/timesheet/time_sheet_filter/controller/time_sheet_filter_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_utils.dart';
import '../../../../web_services/api_constants.dart';

class TimeSheetFilterController extends GetxController {
  final _api = TimeSheetFilterRepository();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isAllVisible = false.obs;

  var filterList = <FilterInfo>[].obs;
  var categoriesList = <FilterInfo>[].obs;
  var selectedSupplierIndex = 0.obs;
  var filterData = FiltersListResponse().obs;

  @override
  void onInit() {
    super.onInit();

    var arguments = Get.arguments;
    if (arguments != null) {
      filterData.value = arguments[AppConstants.intentKey.filterData] ?? "";
      if (filterData != null) {
        if (filterData.value.info != null &&
            filterData.value.info!.isNotEmpty) {
          filterList.addAll(filterData.value.info!);
          if (filterList.isNotEmpty) {
            categoriesList.value = filterList[0].data!;
          }
        }
        setAllButtonVisibility();
        isMainViewVisible.value = true;
      }
    }
  }

  void onSelectSupplier(int index) {
    selectedSupplierIndex.value = index;
    setAllButtonVisibility();
    categoriesList.value = filterList[index].data!;
    for (int j = 0; j < categoriesList.length; j++) {
      FilterInfo categoryInfo = categoriesList[j];
      print(categoryInfo.name);
    }
    categoriesList.refresh();
  }

  void setAllButtonVisibility() {
    // if (filterList[selectedSupplierIndex.value].key == 'all_category') {
    //   isAllVisfilterListible.value = false;
    // } else {
    //   isAllVisible.value = true;
    // }
    // print("isAllVisible:" + isAllVisible.value.toString());
    isAllVisible.value = false;
  }

  void onSelectCategory(index) {
    categoriesList[index].selected = !(categoriesList[index].selected ?? false);
    filterList[selectedSupplierIndex.value].data![index].selected =
        categoriesList[index].selected;
    categoriesList.refresh();
    print("Check:" + categoriesList[index].selected!.toString());
    applyFilter();
  }

  void applyFilter_(int categoryId, String categoryName, String categoryKey) {
    /* FilterInfo supplierInfo = filterList[selectedSupplierIndex.value];
    FilterRequest request = FilterRequest();
    request.supplier =
        supplierInfo.id != null ? supplierInfo.id!.toString() : "";
    request.supplier_key = supplierInfo.key ?? "";
    request.category = categoryId.toString();
    request.category_name = categoryName;
    request.category_key = categoryKey;

    // Get.back(result: request);
    print(jsonEncode(request));
    Get.back(result: jsonEncode(request));*/
  }

  void applyFilter() {
    /* var list = <FilterRequest>[];
    for (int i = 0; i < filterList.length; i++) {
      FilterRequest request = FilterRequest();
      FilterInfo supplierInfo = filterList[i];
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
    print(jsonEncode(list));
    Get.back(result: jsonEncode(list));*/

    Get.back(result: filterData.value);
  }

  void clearFilter() {
    for (int i = 0; i < filterData.value.info!.length; i++) {
      FilterInfo supplierInfo = filterData.value.info![i];
      for (int j = 0; j < supplierInfo.data!.length; j++) {
        FilterInfo categoryInfo = supplierInfo.data![j];
        categoryInfo.selected = false;
      }
    }
    for (int i = 0; i < categoriesList.length; i++) {
      categoriesList[i].selected = false;
      categoriesList.refresh();
    }
  }

  void getFiltersListApi() async {
    Map<String, dynamic> map = {};
    multi.FormData formData = multi.FormData.fromMap(map);
    isLoading.value = true;
    _api.getStockFiltersList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          FiltersListResponse response =
              FiltersListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            isMainViewVisible.value = true;
            if (response.info != null && response.info!.isNotEmpty) {
              filterList.addAll(response.info!);
              if (filterList.isNotEmpty) {
                categoriesList.value = filterList[0].data!;
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
