import 'dart:convert';

import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_repository.dart';
import 'package:belcka/buyer_app/buyer_order/model/buyer_order_invoice_response.dart';
import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/buyer_app/buyer_order_details/controller/buyer_order_details_repository.dart';
import 'package:belcka/buyer_app/buyer_order_details/model/buyer_order_details_response.dart';
import 'package:belcka/buyer_app/create_buyer_order/model/product_request_info.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../pages/common/listener/select_date_listener.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/date_utils.dart';

class BuyerOrderDetailsController extends GetxController
    implements SelectDateListener ,DialogButtonClickListener{
  final _api = BuyerOrderDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;
  RxInt status = 0.obs;
  final searchController = TextEditingController().obs;
  final noteController = TextEditingController().obs;
  final receiveDateController = TextEditingController().obs;
  DateTime? receiveDate;
  final orderInfo = OrderInfo().obs;
  final orderProductsList = <ProductInfo>[].obs;
  List<ProductInfo> tempOrderProductsList = [];
  int orderId = 0;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      orderId = arguments[AppConstants.intentKey.orderId] ?? 0;
    }
    receiveDateController.value.text =
        DateUtil.dateToString(DateTime.now(), DateUtil.DD_MM_YYYY_SLASH);
    orderDetailsApi();
  }

  void orderDetailsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["id"] = orderId;

    _api.orderDetails(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          BuyerOrderDetailsResponse response =
              BuyerOrderDetailsResponse.fromJson(
                  jsonDecode(responseModel.result!));
          orderInfo.value = response.info!;
          status.value = orderInfo.value.status ?? 0;
          tempOrderProductsList.clear();

          for (var info in orderInfo.value.purchaseOrders!) {
            info.cartQty = (info.qty ?? 0) - (info.receivedQty ?? 0);
            tempOrderProductsList.add(info);
          }

          orderProductsList.value = tempOrderProductsList;
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void buyerOrderInvoiceApi(int id) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["id"] = id;
    BuyerOrderRepository().buyerOrderInvoice(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) async {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          BuyerOrderInvoiceResponse response =
              BuyerOrderInvoiceResponse.fromJson(
                  jsonDecode(responseModel.result!));
          String fileUrl = response.invoice ?? "";
          await ImageUtils.openAttachment(
              Get.context!, fileUrl, ImageUtils.getFileType(fileUrl));
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  onClickReceiveOrder() {
    var productList = <ProductRequestInfo>[];
    for (var item in orderProductsList) {
      if ((item.cartQty ?? 0) > 0) {
        ProductRequestInfo info = ProductRequestInfo();
        info.productId = item.productId ?? 0;
        info.qty = (item.cartQty ?? 0).toInt();
        info.price = item.price ?? "";
        productList.add(info);
      }
    }
    if (productList.isNotEmpty) {
      receiveOrderApi(productList);
    } else {
      AppUtils.showToastMessage('msg_receive_at_least_one_qty'.tr);
    }
  }

  void receiveOrderApi(List<ProductRequestInfo> productList) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["order_id"] = orderId;
    map["company_id"] = ApiConstants.companyId;
    map["store_id"] = orderInfo.value.storeId ?? 0;
    map["receive_date"] = StringHelper.getText(receiveDateController.value);
    map["note"] = StringHelper.getText(noteController.value);
    map["product_data"] = productList;
    print(jsonEncode(productList));

    _api.receiveBuyerOrder(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
          isLoading.value = false;
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void onItemClick(int index) {}

  void increaseQty(int index) {
    if ((orderProductsList[index].cartQty ?? 0) <
        ((orderProductsList[index].qty ?? 0) -
            (orderProductsList[index].receivedQty ?? 0))) {
      orderProductsList[index].cartQty =
          (orderProductsList[index].cartQty ?? 0) + 1;
      orderProductsList.refresh();
    }
  }

  void decreaseQty(int index) {
    if ((orderProductsList[index].cartQty ?? 0) > 0) {
      print("orderProductsList[index].cartQty:" +
          (orderProductsList[index].cartQty).toString());

      orderProductsList[index].cartQty =
          (orderProductsList[index].cartQty ?? 0) - 1;
      // orderProductsList[index].cartQty--;

      print("orderProductsList[index].cartQty::" +
          (orderProductsList[index].cartQty).toString());

      orderProductsList.refresh();
    }
  }

  Future<void> searchItem(String value) async {
    print(value);
    List<ProductInfo> results = [];
    if (value.isEmpty) {
      results = tempOrderProductsList;
    } else {
      results = tempOrderProductsList
          .where((element) => (!StringHelper.isEmptyString(element.name) &&
              element.name!.toLowerCase().contains(value.toLowerCase())))
          .toList();
    }
    orderProductsList.value = results;
  }

  void clearSearch() {
    searchController.value.clear();
    searchItem("");
    isSearchEnable.value = false;
  }

  void showDatePickerDialog(String dialogIdentifier, DateTime? date,
      DateTime firstDate, DateTime lastDate) {
    DateUtil.showDatePickerDialog(
        initialDate: date,
        firstDate: firstDate,
        lastDate: lastDate,
        dialogIdentifier: dialogIdentifier,
        selectDateListener: this);
  }

  @override
  void onSelectDate(DateTime date, String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.selectDate) {
      receiveDate = date;
      receiveDateController.value.text =
          DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_DASH);
    }
  }

  Future<void> moveToScreen(
      {required String appRout, dynamic arguments}) async {
    var result = await Get.toNamed(appRout, arguments: arguments);
  }

  void showReceiveOrderDialog() {
    AlertDialogHelper.showAlertDialog(
        "",
        'order_received_msg'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.orderReceived);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.orderReceived) {
      Get.back();
      onClickReceiveOrder();
    }
  }
}
