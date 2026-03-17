import 'dart:convert';
import 'package:belcka/pages/user_orders/order_details/model/order_details_info.dart';
import 'package:belcka/pages/user_orders/order_details/model/order_details_response.dart';
import 'package:belcka/storeman_app/storeman_internal_order_details/controller/storeman_internal_order_details_repository.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["id"] = orderId;
    map["status"] = status;
    if (status == 7){
      map["note"] = note;
    }

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
  void orderAgainAction(bool isAllOrders, int index){
    isLoading.value = true;
    final order = orderDetails[0];

    final Map<String, dynamic> body = isAllOrders
        ? createOrderRequest(
      companyId: ApiConstants.companyId,
      projectId: order.projectId ?? 0,
      addressId: order.addressId ?? 0,
      deliverOn: order.deliverOn ?? "",
      storeId: order.storeId ?? 0,
    )
        : createSingleOrderRequest(
      companyId: ApiConstants.companyId,
      projectId: order.projectId ?? 0,
      addressId: order.addressId ?? 0,
      deliverOn: order.deliverOn ?? "",
      storeId: order.storeId ?? 0,
      index: index,
    );

    print(body);

    _api.createEmployeeOrderAPI(
      data: body,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess) {
          isDataUpdated = true;
          onBackPress();
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage?.isNotEmpty == true) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  Map<String, dynamic> createOrderRequest({
    required int companyId,
    required int projectId,
    required int addressId,
    required String deliverOn,
    required int storeId,
  }) {
    return {
      "company_id": companyId,
      "project_id": projectId,
      if (addressId > 0) "address_id": addressId,
      if (storeId > 0) "store_id": storeId,
      "deliver_on": deliverOn,
      "product_data": orderDetails[0].orders?.map((item) {
        return {
          "product_id": item.productId,
          "qty": (item.isSubQty ?? false) ? item.subQty : item.qty,
          "price": item.marketPrice,
          "is_sub_qty":item.isSubQty
        };
      }).toList(),
    };
  }

  Map<String, dynamic> createSingleOrderRequest({
    required int companyId,
    required int projectId,
    required int addressId,
    required String deliverOn,
    required int storeId,
    required int index,
  }) {

    final item = orderDetails[0].orders![index];

    return {
      "company_id": companyId,
      "project_id": projectId,
      if (addressId > 0) "address_id": addressId,
      if (storeId > 0) "store_id": storeId,
      "deliver_on": deliverOn,
      "product_data": [
        {
          "product_id": item.productId,
          "qty":(item.isSubQty ?? false) ? item.subQty : item.qty,
          "price": item.marketPrice,
          "is_sub_qty":item.isSubQty
        }
      ],
    };
  }

  void updateSubQty(int index, int count) {
    final order = orderDetails[0].orders ?? [];
    final product = order[index].product;
    product?.cartQty = count.toDouble();
  }
  void increaseQty(int index) {
    final order = orderDetails[0].orders ?? [];
    final product = order[index].product;
    double userQty = (product?.cartQty ?? 0.0) + 1;
    product?.cartQty = userQty;
  }

  void decreaseQty(int index) {
    final order = orderDetails[0].orders ?? [];
    final product = order[index].product;
    double userQty = product?.cartQty ?? 0.0;
    if (userQty == 0 || userQty == 1) return;
    product?.cartQty = userQty - 1;
  }
}