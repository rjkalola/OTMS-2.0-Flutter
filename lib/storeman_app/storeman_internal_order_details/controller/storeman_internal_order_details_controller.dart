import 'dart:convert';
import 'package:belcka/pages/user_orders/order_details/model/order_details_info.dart';
import 'package:belcka/pages/user_orders/order_details/model/order_details_response.dart';
import 'package:belcka/storeman_app/storeman_internal_order_details/controller/storeman_internal_order_details_repository.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

class StoremanInternalOrderDetailsController extends GetxController{
  RxBool isDeliverySelected = true.obs;
  final _api = StoremanInternalOrderDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;
  bool isDataUpdated = false;

  RxList<OrderDetailsInfo> orderDetails = <OrderDetailsInfo>[].obs;
  List<OrderDetailsInfo> tempList = [];
  String orderId = "";
  bool canShowActionButtons = false;
  RxInt status = 0.obs;
  List<FocusNode> qtyFocusNodes = [];

  void initFocusNodes(int length) {
    qtyFocusNodes = List.generate(length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var node in qtyFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      orderId = arguments["order_id"] ?? "";
      canShowActionButtons = arguments["canShowActionButtons"] ?? false;
    }
    fetchOrderDetails();
  }
  void fetchOrderDetails() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["id"] = orderId;

    _api.getOrderHistoryAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          OrderDetailsResponse response =
          OrderDetailsResponse.fromJson(jsonDecode(responseModel.result!));

          tempList.clear();
          tempList.addAll(response.info ?? []);

          orderDetails.value = tempList;
          orderDetails.refresh();

          status.value = orderDetails[0].status ?? 0;
          initFocusNodes(orderDetails[0].orders?.length ?? 0);

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

  void onBackPress() {
    Get.back(result: isDataUpdated);
  }

  void updateOrderStatus(int status, String note){
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["id"] = orderId;
    map["status"] = status;
    if (status == 7){
      map["note"] = note;
    }
    else if (status == 6) {

      final allOrders = orderDetails[0].orders ?? [];
      final selectedItems = allOrders.where((item) => item.isSelected).toList();

      bool missingRequiredNotes = selectedItems.any((item) =>
      (item.isQuantityChanged ?? false) && (item.note == null || item.note!.trim().isEmpty)
      );

      if (missingRequiredNotes) {
        AppUtils.showToastMessage("Please add a note for items with changed quantities.".tr);
        return;
      }

      List<Map<String, dynamic>> productList = [];

      for (var item in selectedItems) {
        productList.add({
          "id": item.productId,
          //"qty": (item.isSubQty ?? false) ? item.subQty : item.qty,
          "qty": item.remainingQty,
          "note": item.note,
        });
      }
      map["product_data"] = productList;
      print("JSON Payload: $map");
    }
    isLoading.value = true;
    _api.updateOrderStatusAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isDataUpdated = true;
          fetchOrderDetails();
        }
        else{
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

  void updateSubQty(int index, int count) {
    print("$count");
    final orders = orderDetails[0].orders ?? [];
    final order = orders[index];
    if (count == 0) return;
    order.remainingQty = "${count.toDouble()}";
    order.isQuantityChanged = true;
  }

  void increaseQty(int index) {
    final orders = orderDetails[0].orders ?? [];
    final order = orders[index];
    double userQty = ((double.tryParse(order.remainingQty ?? "") ?? 0.00).toInt()) + 1;
    order.remainingQty = "$userQty";
    order.isQuantityChanged = true;
  }

  void decreaseQty(int index) {
    final orders = orderDetails[0].orders ?? [];
    final order = orders[index];
    double userQty = (double.tryParse(order.remainingQty ?? "") ?? 0.00);
    if (userQty == 0 || userQty == 1) return;
    order.remainingQty = "${userQty - 1}";
    order.isQuantityChanged = true;
  }

  int getSelectedItemsCount(){
    final orders = orderDetails[0].orders ?? [];
    return orders.where((item) => item.isSelected == true).length;
  }
}