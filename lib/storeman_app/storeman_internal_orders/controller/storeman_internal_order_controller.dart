import 'dart:convert';
import 'package:belcka/buyer_app/buyer_order/model/buyer_orders_list_response.dart';
import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/storeman_app/storeman_internal_orders/controller/storeman_internal_order_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/enums/internal_order_status.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoremanInternalOrderController extends GetxController {
  final _api = StoremanInternalOrderRepository();

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs;

  RxString startDate = "".obs, endDate = "".obs;
  RxInt selectedDateFilterIndex = (-1).obs;

  final selectedTab = InternalOrderStatus.newOrders.obs;
  final searchController = TextEditingController().obs;

  final ordersList = <OrderInfo>[].obs;
  List<OrderInfo> tempOrdersList = [];

  RxInt newCount = 0.obs,
      preparingCount = 0.obs,
      readyCount = 0.obs,
      collectedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      String selectedTabType =
          arguments[AppConstants.intentKey.selectedTabType] ?? "";

      if (selectedTabType == AppConstants.type.newType) {
        selectedTab.value = InternalOrderStatus.newOrders;
      } else if (selectedTabType == AppConstants.type.preparing) {
        selectedTab.value = InternalOrderStatus.preparing;
      } else if (selectedTabType == AppConstants.type.ready) {
        selectedTab.value = InternalOrderStatus.ready;
      } else if (selectedTabType == AppConstants.type.collect) {
        selectedTab.value = InternalOrderStatus.collected;
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
    getInternalOrdersApi();
  }

  void getInternalOrdersApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {
      "company_id": ApiConstants.companyId,
      "status": getStatusParameterValue(),
      "start_date": startDate.value,
      "end_date": endDate.value,
    };

    _api.getStoremanInternalOrders(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          BuyerOrdersListResponse response = BuyerOrdersListResponse.fromJson(
              jsonDecode(responseModel.result!));

          tempOrdersList = response.info ?? [];
          ordersList.assignAll(tempOrdersList);

          updateTabCount(response.newOrders ?? 0, response.preparing ?? 0,
              response.ready ?? 0, response.collected ?? 0);
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
    if (selectedTab.value == InternalOrderStatus.newOrders) {
      status = "1";
    } else if (selectedTab.value == InternalOrderStatus.preparing) {
      status = "4";
    } else if (selectedTab.value == InternalOrderStatus.ready) {
      status = "3";
    } else if (selectedTab.value == InternalOrderStatus.collected) {
      status = "2";
    }
    return status;
  }

  void updateTabCount(int new_, int preparing, int ready, int collected) {
    newCount.value = new_;
    preparingCount.value = preparing;
    readyCount.value = ready;
    collectedCount.value = collected;
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
