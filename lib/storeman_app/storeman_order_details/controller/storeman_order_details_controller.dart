import 'dart:convert';

import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_repository.dart';
import 'package:belcka/buyer_app/buyer_order/model/buyer_order_invoice_response.dart';
import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/buyer_app/buyer_order_details/model/buyer_order_details_response.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/select_date_listener.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/storeman_app/storeman_order_details/controller/storeman_order_details_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../utils/AlertDialogHelper.dart';

class StoremanOrderDetailsController extends GetxController
    implements SelectDateListener, DialogButtonClickListener {
  final _api = StoremanOrderDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs;
  RxInt status = 0.obs;
  final searchController = TextEditingController().obs;
  final noteController = TextEditingController().obs;
  final receiveDateController = TextEditingController().obs;
  DateTime? receiveDate;
  final orderInfo = OrderInfo().obs;
  final orderProductsList = <ProductInfo>[].obs;
  List<ProductInfo> tempOrderProductsList = [];
  int orderId = 0, initialStatus = 0;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      orderId = arguments[AppConstants.intentKey.orderId] ?? 0;
      initialStatus = arguments[AppConstants.intentKey.status] ?? 0;
    }
    receiveDateController.value.text =
        DateUtil.dateToString(DateTime.now(), DateUtil.DD_MM_YYYY_SLASH);
    orderDetailsApi();
  }

  void orderDetailsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {
      "company_id": ApiConstants.companyId,
      "id": orderId,
    };

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
          status.value =
              initialStatus != 0 ? initialStatus : orderInfo.value.status ?? 0;
          tempOrderProductsList.clear();

          for (var info in orderInfo.value.purchaseOrders!) {
            info.cartQty = (info.qty ?? 0);
            tempOrderProductsList.add(info);
          }

          orderProductsList.assignAll(tempOrderProductsList);
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

  // void onClickReceiveOrder() {
  //   var productList = <ProductRequestInfo>[];
  //   for (var item in orderProductsList) {
  //     if ((item.cartQty ?? 0) > 0) {
  //       ProductRequestInfo info = ProductRequestInfo();
  //       info.productId = item.productId ?? 0;
  //       info.qty = (item.cartQty ?? 0).toInt();
  //       info.price = item.price ?? "";
  //       productList.add(info);
  //     }
  //   }
  //   if (productList.isNotEmpty) {
  //     receiveOrderApi(productList);
  //   } else {
  //     AppUtils.showToastMessage('msg_receive_at_least_one_qty'.tr);
  //   }
  // }

  void proceedOrder() async {
    Map<String, dynamic> map = {};
    map["id"] = orderId;
    map["company_id"] = ApiConstants.companyId;
    map["status"] = status.value == AppConstants.orderStatus.received
        ? AppConstants.orderStatus.processing
        : AppConstants.orderStatus.onStock;
    print("map:" + map.toString());
    multi.FormData formData = multi.FormData.fromMap(map);

    /*  multi.FormData formData = multi.FormData.fromMap(map);
    print("reques value:" + map.toString());
    print("mCompanyLogo.value:" + mCompanyLogo.value.toString());

    if (!StringHelper.isEmptyString(mCompanyLogo.value) &&
        !mCompanyLogo.startsWith("http")) {
      // final mimeType = lookupMimeType(file. path);
      formData.files.add(
        MapEntry("company_image",
            await multi.MultipartFile.fromFile(mCompanyLogo.value)),
      );
    }*/

    isLoading.value = true;
    _api.proceedStoremanOrder(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  // void receiveOrderApi(List<ProductRequestInfo> productList) {
  //   isLoading.value = true;
  //   Map<String, dynamic> map = {
  //     "order_id": orderId,
  //     "company_id": ApiConstants.companyId,
  //     "store_id": orderInfo.value.storeId ?? 0,
  //     "receive_date": StringHelper.getText(receiveDateController.value),
  //     "note": StringHelper.getText(noteController.value),
  //     "product_data": productList,
  //   };
  //
  //   _api.receiveStoremanOrder(
  //     data: map,
  //     onSuccess: (ResponseModel responseModel) {
  //       if (responseModel.isSuccess) {
  //         BaseResponse response =
  //             BaseResponse.fromJson(jsonDecode(responseModel.result!));
  //         AppUtils.showToastMessage(response.Message ?? "");
  //         Get.back(result: true);
  //       } else {
  //         isLoading.value = false;
  //         AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
  //       }
  //     },
  //     onError: (ResponseModel error) {
  //       isLoading.value = false;
  //       if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
  //         isInternetNotAvailable.value = true;
  //       } else if (error.statusMessage!.isNotEmpty) {
  //         AppUtils.showSnackBarMessage(error.statusMessage ?? "");
  //       }
  //     },
  //   );
  // }

  void increaseQty(int index) {
    // if ((orderProductsList[index].cartQty ?? 0) <
    //     ((orderProductsList[index].qty ?? 0) -
    //         (orderProductsList[index].receivedQty ?? 0))) {
    orderProductsList[index].cartQty =
        (orderProductsList[index].cartQty ?? 0) + 1;
    orderProductsList.refresh();
    // }
  }

  void decreaseQty(int index) {
    if ((orderProductsList[index].cartQty ?? 0) > 0) {
      orderProductsList[index].cartQty =
          (orderProductsList[index].cartQty ?? 0) - 1;
      orderProductsList.refresh();
    }
  }

  void onItemClick(int index) {}

  void searchItem(String value) {
    if (value.isEmpty) {
      orderProductsList.assignAll(tempOrderProductsList);
    } else {
      orderProductsList.assignAll(tempOrderProductsList
          .where((element) => (element.name != null &&
              element.name!.toLowerCase().contains(value.toLowerCase())))
          .toList());
    }
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
          DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_SLASH);
    }
  }

  void showOrderProceedDialog() {
    AlertDialogHelper.showAlertDialog(
        "",
        'order_proceed_msg'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.orderProceed);
  }

  void showOrderDeliveredDialog() {
    AlertDialogHelper.showAlertDialog(
        "",
        'order_deliver_msg'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.orderDelivered);
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
    if (dialogIdentifier == AppConstants.dialogIdentifier.orderDelivered) {
      Get.back();
      proceedOrder();
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.orderProceed) {
      Get.back();
      proceedOrder();
    }
  }
}
