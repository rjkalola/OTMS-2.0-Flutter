import 'dart:convert';
import 'package:belcka/buyer_app/buyer_order/model/buyer_product_list_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/storeman_app/storeman_hire_products/controller/storeman_hire_product_repository.dart';
import 'package:belcka/storeman_app/storeman_internal_orders/controller/storeman_internal_order_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/enums/hire_product_status.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoremanHireProductController extends GetxController {
  final _api = StoremanHireProductRepository(); // Using internal order repository as placeholder

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs;

  RxString startDate = "".obs, endDate = "".obs;
  RxInt selectedDateFilterIndex = (-1).obs;

  final selectedTab = HireProductStatus.request.obs;
  final searchController = TextEditingController().obs;

  final productsList = <ProductInfo>[].obs;
  List<ProductInfo> tempProductsList = [];

  RxInt requestCount = 0.obs,
      hiredCount = 0.obs,
      availableCount = 0.obs,
      serviceCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      String selectedTabType =
          arguments[AppConstants.intentKey.selectedTabType] ?? "";
      
      if (selectedTabType == AppConstants.type.request) {
        selectedTab.value = HireProductStatus.request;
      } else if (selectedTabType == AppConstants.type.hired) {
        selectedTab.value = HireProductStatus.hired;
      } else if (selectedTabType == AppConstants.type.available) {
        selectedTab.value = HireProductStatus.available;
      } else if (selectedTabType == AppConstants.type.servicing) {
        selectedTab.value = HireProductStatus.service;
      }
      
      selectedDateFilterIndex.value =
          arguments[AppConstants.intentKey.index] ?? -1;
      startDate.value = arguments[AppConstants.intentKey.startDate] ?? "";
      endDate.value = arguments[AppConstants.intentKey.endDate] ?? "";
    }
    loadData();
  }

  void loadData() {
    clearSearch();
    getHireProductsApi();
  }

  void getHireProductsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {
      "company_id": ApiConstants.companyId,
      // Status mapping if needed for the products API
    };

    _api.getHireProducts( // Reusing for now as requested
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          BuyerProductListResponse response = BuyerProductListResponse.fromJson(
              jsonDecode(responseModel.result!));

          tempProductsList = response.info ?? [];
          productsList.assignAll(tempProductsList);
          updateCurrentTabCount(response.info?.length ?? 0);
          
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

  void updateCurrentTabCount(int count) {
    switch (selectedTab.value) {
      case HireProductStatus.request:
        requestCount.value = count;
        break;
      case HireProductStatus.hired:
        hiredCount.value = count;
        break;
      case HireProductStatus.available:
        availableCount.value = count;
        break;
      case HireProductStatus.service:
        serviceCount.value = count;
        break;
    }
  }

  void searchItem(String value) {
    if (value.isEmpty) {
      productsList.assignAll(tempProductsList);
    } else {
      String query = value.toLowerCase();
      productsList.assignAll(tempProductsList
          .where((element) =>
              (element.shortName != null &&
                  element.shortName!.toLowerCase().contains(query)) ||
              (element.uuid != null &&
                  element.uuid!.toLowerCase().contains(query)))
          .toList());
    }
    productsList.refresh();
  }

  void clearSearch() {
    searchController.value.clear();
    isSearchEnable.value = false;
    searchItem("");
  }
}
