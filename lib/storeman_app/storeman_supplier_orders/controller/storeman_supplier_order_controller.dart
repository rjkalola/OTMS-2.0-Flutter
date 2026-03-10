import 'dart:convert';
import 'package:belcka/buyer_app/buyer_order/model/buyer_orders_list_response.dart';
import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/storeman_app/storeman_supplier_orders/controller/storeman_supplier_order_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/enums/supplier_order_status.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoremanSupplierOrderController extends GetxController {
  final _api = StoremanSupplierOrderRepository();

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs;

  RxString startDate = "".obs, endDate = "".obs;
  RxInt selectedDateFilterIndex = (-1).obs;

  final selectedTab = SupplierOrderStatus.all.obs;
  final searchController = TextEditingController().obs;

  final ordersList = <OrderInfo>[].obs;
  List<OrderInfo> tempOrdersList = [];

  RxInt allCount = 0.obs,
      upcomingCount = 0.obs,
      processingCount = 0.obs,
      onStockCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      String selectedTabType =
          arguments[AppConstants.intentKey.selectedTabType] ?? "";
      
     if (selectedTabType == AppConstants.type.upComing) {
        selectedTab.value = SupplierOrderStatus.upcoming;
      } else if (selectedTabType == AppConstants.type.processing) {
        selectedTab.value = SupplierOrderStatus.processing;
      } else if (selectedTabType == AppConstants.type.onStock) {
        selectedTab.value = SupplierOrderStatus.onStock;
      }else {
        selectedTab.value = SupplierOrderStatus.all;
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
    getSupplierOrdersApi(selectedTab.value.value.toString());
  }

  void getSupplierOrdersApi(String status) {
    isLoading.value = true;
    Map<String, dynamic> map = {
      "company_id": ApiConstants.companyId,
      "status": status,
      "start_date": startDate.value,
      "end_date": endDate.value,
    };

    _api.getSupplierOrders(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          BuyerOrdersListResponse response = BuyerOrdersListResponse.fromJson(
              jsonDecode(responseModel.result!));

          tempOrdersList = response.info ?? [];
          ordersList.assignAll(tempOrdersList);
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
      case SupplierOrderStatus.all:
        allCount.value = count;
        break;
      case SupplierOrderStatus.upcoming:
        upcomingCount.value = count;
        break;
      case SupplierOrderStatus.processing:
        processingCount.value = count;
        break;
      case SupplierOrderStatus.onStock:
        onStockCount.value = count;
        break;
    }
  }

  void searchItem(String value) {
    if (value.isEmpty) {
      ordersList.assignAll(tempOrdersList);
    } else {
      String query = value.toLowerCase();
      ordersList.assignAll(tempOrdersList
          .where((element) =>
              (element.orderNumber != null &&
                  element.orderNumber!.toLowerCase().contains(query)) ||
              (element.orderId != null &&
                  element.orderId!.toLowerCase().contains(query)) ||
              (element.supplierName != null &&
                  element.supplierName!.toLowerCase().contains(query)) ||
              (element.userName != null &&
                  element.userName!.toLowerCase().contains(query)))
          .toList());
    }
    ordersList.refresh();
  }

  void clearSearch() {
    searchController.value.clear();
    isSearchEnable.value = false;
    searchItem("");
  }
}
