import 'dart:convert';

import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_repository.dart';
import 'package:belcka/buyer_app/buyer_order/model/buyer_order_invoice_response.dart';
import 'package:belcka/buyer_app/buyer_order/model/buyer_orders_list_response.dart';
import 'package:belcka/buyer_app/buyer_order/model/buyer_product_list_response.dart';
import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/enums/order_tab_type.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BuyerOrderController extends GetxController
    implements DialogButtonClickListener {
  final _api = BuyerOrderRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;
  double cardRadius = 12;
  int selectedIndex = 0;
  RxInt requestCount = 0.obs, proceedCount = 0.obs, deliveredCount = 0.obs;
  final searchController = TextEditingController().obs;
  final requestOrdersList = <ProductInfo>[].obs;
  final proceedOrdersList = <OrderInfo>[].obs;
  final deliveredOrdersList = <OrderInfo>[].obs;
  List<ProductInfo> tempRequestOrderList = [];
  List<OrderInfo> tempProceedOrderList = [];
  List<OrderInfo> tempDeliveredOrderList = [];
  final selectedTab = OrderTabType.request.obs;

  final ScrollController requestScrollController = ScrollController();
  final ScrollController proceedScrollController = ScrollController();
  final ScrollController deliveredScrollController = ScrollController();

  final List<FocusNode> qtyFocusNodes = [];

  FocusNode getQtyFocusNode(int index) {
    if (qtyFocusNodes.length <= index) {
      qtyFocusNodes.add(FocusNode());
    }
    return qtyFocusNodes[index];
  }

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      String selectedTabType =
          arguments[AppConstants.intentKey.selectedTabType] ?? "";
      if (selectedTabType == AppConstants.type.request) {
        selectedTab.value = OrderTabType.request;
      } else if (selectedTabType == AppConstants.type.proceed) {
        selectedTab.value = OrderTabType.proceed;
      } else if (selectedTabType == AppConstants.type.delivered) {
        selectedTab.value = OrderTabType.delivered;
      }
    }
    loadData();
  }

  void loadData() {
    clearSearch();
    if (selectedTab.value == OrderTabType.request) {
      buyerProductsListApi();
    } else if (selectedTab.value == OrderTabType.proceed) {
      buyerOrdersListApi("0,1");
    } else if (selectedTab.value == OrderTabType.delivered) {
      buyerOrdersListApi("2");
    }
  }

  void buyerProductsListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.buyerProductsList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          BuyerProductListResponse response = BuyerProductListResponse.fromJson(
              jsonDecode(responseModel.result!));

          tempRequestOrderList.clear();
          tempRequestOrderList.addAll(response.info!);
          requestOrdersList.value = tempRequestOrderList;
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

  void buyerOrdersListApi(String status) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["status"] = status;
    _api.buyerOrdersList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          BuyerOrdersListResponse response = BuyerOrdersListResponse.fromJson(
              jsonDecode(responseModel.result!));

          if (status == "0,1") {
            tempProceedOrderList.clear();
            tempProceedOrderList.addAll(response.info ?? []);
            proceedOrdersList.value = tempProceedOrderList;
          } else if (status == "2") {
            tempDeliveredOrderList.clear();
            tempDeliveredOrderList.addAll(response.info ?? []);
            deliveredOrdersList.value = tempDeliveredOrderList;
          }
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
    _api.buyerOrderInvoice(
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

  void increaseQty(int index) {
    // if (requestOrdersList[index].cartQty < requestOrdersList[index].availableQty) {
    requestOrdersList[index].cartQty =
        (requestOrdersList[index].cartQty ?? 0) + 1;
    requestOrdersList.refresh();
    // }
  }

  void decreaseQty(int index) {
    if ((requestOrdersList[index].cartQty ?? 0) > 0) {
      print("requestOrdersList[index].cartQty:" +
          (requestOrdersList[index].cartQty).toString());

      requestOrdersList[index].cartQty =
          (requestOrdersList[index].cartQty ?? 0) - 1;
      // requestOrdersList[index].cartQty--;

      print("requestOrdersList[index].cartQty::" +
          (requestOrdersList[index].cartQty).toString());

      requestOrdersList.refresh();
    }
  }

  void removeItem(int index) {
    selectedIndex = index;
    showDeleteDialog();
  }

  void onItemClick(int index) {
    if (selectedTab.value == OrderTabType.request) {
    } else if (selectedTab.value == OrderTabType.proceed) {
      var arguments = {
        AppConstants.intentKey.orderId: proceedOrdersList[index].id ?? 0,
      };
      moveToScreen(
          appRout: AppRoutes.buyerOrderDetailsScreen, arguments: arguments);
    } else if (selectedTab.value == OrderTabType.delivered) {
      var arguments = {
        AppConstants.intentKey.orderId: deliveredOrdersList[index].id ?? 0,
      };
      moveToScreen(
          appRout: AppRoutes.buyerOrderDetailsScreen, arguments: arguments);
    }
  }

  // double get grandTotal =>
  //     requestOrdersList.fold(0, (sum, item) => sum + item.totalPrice);

  void setQty(int index, int qty) {
    final item = requestOrdersList[index];

    int finalQty;

    if (qty < 1) {
      finalQty = 0;
    } else if (qty > (item.qty ?? 0)) {
      finalQty = item.qty ?? 0;
    } else {
      finalQty = qty;
    }

    item.cartQty = finalQty;
    requestOrdersList.refresh();
  }

  void showDeleteDialog() {
    AlertDialogHelper.showAlertDialog(
        "",
        'are_you_sure_you_want_to_delete'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.delete);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.delete) {
      Get.back();
    }
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.delete) {
      Get.back();
      requestOrdersList.removeAt(selectedIndex);
    }
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  Future<void> searchItem(String value) async {
    print(value);
    if (selectedTab.value == OrderTabType.request) {
      List<ProductInfo> results = [];
      if (value.isEmpty) {
        results = tempRequestOrderList;
      } else {
        results = tempRequestOrderList
            .where((element) => (!StringHelper.isEmptyString(element.name) &&
                element.name!.toLowerCase().contains(value.toLowerCase())))
            .toList();
      }
      requestOrdersList.value = results;
    } else if (selectedTab.value == OrderTabType.proceed) {
      List<OrderInfo> results = [];
      if (value.isEmpty) {
        results = tempProceedOrderList;
      } else {
        results = tempProceedOrderList
            .where((element) =>
                (!StringHelper.isEmptyString(element.supplierName) &&
                    element.supplierName!
                        .toLowerCase()
                        .contains(value.toLowerCase())))
            .toList();
      }
      proceedOrdersList.value = results;
    } else if (selectedTab.value == OrderTabType.delivered) {
      List<OrderInfo> results = [];
      if (value.isEmpty) {
        results = tempDeliveredOrderList;
      } else {
        results = tempDeliveredOrderList
            .where((element) =>
                (!StringHelper.isEmptyString(element.supplierName) &&
                    element.supplierName!
                        .toLowerCase()
                        .contains(value.toLowerCase())))
            .toList();
      }
      deliveredOrdersList.value = results;
    }
  }

  void clearSearch() {
    searchController.value.clear();
    searchItem("");
    isSearchEnable.value = false;
  }

  Future<void> moveToCreateOrderScreen(
      {required String appRout, dynamic arguments}) async {
    var result = await Get.toNamed(appRout, arguments: arguments);
    if (result != null && result) {
      selectedTab.value = OrderTabType.proceed;
      loadData();
    }
  }

  Future<void> moveToScreen(
      {required String appRout, dynamic arguments}) async {
    var result = await Get.toNamed(appRout, arguments: arguments);
    if (result != null && result) {
      loadData();
    }
  }

  @override
  void onClose() {
    for (final node in qtyFocusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
