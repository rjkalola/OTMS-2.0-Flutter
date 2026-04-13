import 'dart:convert';
import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/pages/user_orders/order_history/controller/order_history_repository.dart';
import 'package:belcka/pages/user_orders/order_history/model/order_history_response.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum OrderFilter {
  all,
  ready,
  collected,
  returned,
  cancelled,
}

class OrderHistoryController extends GetxController {
  RxBool isDeliverySelected = true.obs;
  final _api = OrderHistoryRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;

  RxList<OrderInfo> orderList = <OrderInfo>[].obs;
  List<OrderInfo> tempList = [];
  Rx<OrderFilter> selectedFilter = OrderFilter.all.obs;

  bool isDataUpdated = false;

  final searchController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrderHistory();
  }

  String getStatusFromFilter(OrderFilter filter) {
    switch (filter) {
      case OrderFilter.ready:
        return AppConstants.internalOrderStatus.ready.toString();
      case OrderFilter.collected:
        return "${AppConstants.internalOrderStatus.collected},${AppConstants.internalOrderStatus.delivered}";
      case OrderFilter.returned:
        return AppConstants.internalOrderStatus.returned.toString();
      case OrderFilter.cancelled:
        return AppConstants.internalOrderStatus.cancelled.toString();
      case OrderFilter.all:
        return "";
    }
  }

  static const int _statusDelivered = 6;
  static const int _statusCollected = 2;

  void _applyOrderHistorySuccess(OrderHistoryResponse response) {
    tempList.clear();
    tempList.addAll(response.info ?? []);
    orderList.value = tempList;
    orderList.refresh();
    isMainViewVisible.value = true;
    isLoading.value = false;
  }

  void changeFilter(OrderFilter filter) {
    if (selectedFilter.value == filter) return;
    selectedFilter.value = filter;
    clearSearch();
    fetchOrderHistory();
  }

  void fetchOrderHistory() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;

    final statusValue = getStatusFromFilter(selectedFilter.value);
    if (!StringHelper.isEmptyString(statusValue)) {
      map["status"] = statusValue;
    }

    _api.getOrderHistoryAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          OrderHistoryResponse response =
              OrderHistoryResponse.fromJson(jsonDecode(responseModel.result!));

          _applyOrderHistorySuccess(response);
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
          isLoading.value = false;
        }
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

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated = true;
      clearSearch();
      fetchOrderHistory();
    }
  }

  Future<void> searchItem(String value) async {
    List<OrderInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) =>
              (!StringHelper.isEmptyString(element.orderNumber) &&
                  element.orderNumber!
                      .toLowerCase()
                      .contains(value.toLowerCase())))
          .toList();
    }
    orderList.value = results;
  }

  void clearSearch() {
    searchController.value.clear();
    searchItem("");
  }

  void onBackPress() {
    Get.back(result: isDataUpdated);
  }
}
