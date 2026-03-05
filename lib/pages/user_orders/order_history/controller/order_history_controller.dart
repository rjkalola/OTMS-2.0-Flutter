import 'dart:convert';
import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/pages/user_orders/order_history/controller/order_history_repository.dart';
import 'package:belcka/pages/user_orders/order_history/model/order_history_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

enum OrderFilter {
  all,
  delivered,
  collected,
  returned,
  cancelled,
}

class OrderHistoryController extends GetxController{
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

  List<OrderInfo> get filteredOrders {
    switch (selectedFilter.value) {
      case OrderFilter.delivered:
        return orderList.where((o) => o.status == 7).toList();

      case OrderFilter.collected:
        return orderList.where((o) => o.status == 6).toList();

      case OrderFilter.returned:
        return orderList.where((o) => o.status == 9).toList();

      case OrderFilter.cancelled:
        return orderList
            .where((o) => o.status == 3 || o.status == 8)
            .toList();
      case OrderFilter.all:

      return orderList;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // TODO: implement onInit
    fetchOrderHistory();
  }
  int getStatusFromFilter(OrderFilter filter) {
    switch (filter) {
      case OrderFilter.delivered:
        return 7;
      case OrderFilter.collected:
        return 6;
      case OrderFilter.returned:
        return 9;
      case OrderFilter.cancelled:
        return 8; // or 3 if needed
      case OrderFilter.all:
        return 1; // all
    }
  }
  void changeFilter(OrderFilter filter) {
    if (selectedFilter.value == filter) return;
    selectedFilter.value = filter;
    fetchOrderHistory();
  }
  void fetchOrderHistory() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;

    final statusValue = getStatusFromFilter(selectedFilter.value);
    if (statusValue > 1){
      map["status"] = statusValue;
    }

    _api.getOrderHistoryAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          OrderHistoryResponse response =
          OrderHistoryResponse.fromJson(jsonDecode(responseModel.result!));

          tempList.clear();
          tempList.addAll(response.info ?? []);
          orderList.value = tempList;
          orderList.refresh();
          isMainViewVisible.value = true;
          isLoading.value = false;
        }
        else{
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
      fetchOrderHistory();
    }
  }
}