import 'dart:convert';

import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_repository.dart';
import 'package:belcka/buyer_app/buyer_order/model/buyer_orders_list_response.dart';
import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/routes/app_routes.dart';
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
      } else {
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
    getSupplierOrdersApi();
  }

  void getSupplierOrdersApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {
      "company_id": ApiConstants.companyId,
      "status": getStatusParameterValue(),
      "start_date": startDate.value,
      "end_date": endDate.value,
    };

    BuyerOrderRepository().buyerOrdersList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          BuyerOrdersListResponse response = BuyerOrdersListResponse.fromJson(
              jsonDecode(responseModel.result!));
          tempOrdersList = response.info ?? [];
          ordersList.assignAll(tempOrdersList);
          ordersList.refresh();
          updateTabCount(response.upcoming ?? 0, response.processing ?? 0,
              response.delivered ?? 0);
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

  String getStatusParameterValue() {
    String status = "";
    if (selectedTab.value == SupplierOrderStatus.all) {
      status = "1,2,3,5";
    } else if (selectedTab.value == SupplierOrderStatus.upcoming) {
      status = "2";
    } else if (selectedTab.value == SupplierOrderStatus.processing) {
      status = "1,3";
    } else if (selectedTab.value == SupplierOrderStatus.onStock) {
      status = "5";
    }
    return status;
  }

  void updateTabCount(int upcoming, int processing, int onStock) {
    allCount.value = 0;
    upcomingCount.value = upcoming;
    processingCount.value = processing;
    onStockCount.value = onStock;
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
              (element.storeName != null &&
                  element.storeName!.toLowerCase().contains(query)) ||
              (element.supplierName != null &&
                  element.supplierName!.toLowerCase().contains(query)) ||
              (element.userName != null &&
                  element.userName!.toLowerCase().contains(query)))
          .toList());
    }
    ordersList.refresh();
  }

  void onItemClick(int id, int status) {
    print("status:" + status.toString());
    var arguments = {
      AppConstants.intentKey.orderId: id,
      AppConstants.intentKey.status: status,
    };
    moveToScreen(
        appRout: AppRoutes.storemanOrderDetailsScreen, arguments: arguments);
  }

  Future<void> moveToScreen(
      {required String appRout, dynamic arguments}) async {
    var result = await Get.toNamed(appRout, arguments: arguments);
    if (result != null) {
      var arguments = result;
      if (arguments != null) {
        int status = arguments[AppConstants.intentKey.status] ?? 0;
        bool result = arguments[AppConstants.intentKey.result] ?? false;
        if (result) {
          if (status == AppConstants.orderStatus.processing ||
              status == AppConstants.orderStatus.partialReceived) {
            selectedTab.value = SupplierOrderStatus.processing;
          } else if (status == AppConstants.orderStatus.inStock) {
            selectedTab.value = SupplierOrderStatus.onStock;
          } else {
            selectedTab.value = SupplierOrderStatus.all;
          }
        }
      }
      loadData();
    }
  }

  void clearSearch() {
    searchController.value.clear();
    isSearchEnable.value = false;
    searchItem("");
  }
}
