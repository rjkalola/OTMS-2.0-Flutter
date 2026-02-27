import 'dart:convert';

import 'package:belcka/buyer_app/create_buyer_order/controller/create_buyer_order_repository.dart';
import 'package:belcka/buyer_app/create_buyer_order/model/product_request_info.dart';
import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/select_date_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/model/Dropdown_list_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/web_services/response/base_response.dart';

import '../../../web_services/api_constants.dart';

class CreateBuyerOrderController extends GetxController
    implements
        DialogButtonClickListener,
        SelectItemListener,
        SelectDateListener {
  final _api = CreateBuyerOrderRepository();
  final orderIdController = TextEditingController().obs;
  final expectedDeliveryController = TextEditingController().obs;
  final storeController = TextEditingController().obs;
  final supplierController = TextEditingController().obs;
  final refController = TextEditingController().obs;
  final noteController = TextEditingController().obs;
  DateTime? expectedDeliveryDate;
  List<ModuleInfo> listSuppliers = [];
  List<ModuleInfo> listStores = [];

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs,
      isCheckedProduct = false.obs;
  RxString currency = "".obs;
  RxDouble uniteTotal = 0.0.obs;
  final formKey = GlobalKey<FormState>();
  double cardRadius = 12;
  int selectedIndex = 0, storeId = 0, supplierId = 0;
  final buyerOrdersList = <ProductInfo>[].obs;
  List<ProductInfo> tempBuyerOrderList = [];
  final searchController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      buyerOrdersList.value =
          arguments[AppConstants.intentKey.productsData] ?? [];
      if (buyerOrdersList.isNotEmpty) {
        currency.value = buyerOrdersList[0].currency ?? "";
      }
      calculateTotalAmount();
    }
    getSuppliersApi();
  }

  void loadOrders() {
    // tempBuyerOrderList.clear();
    // tempBuyerOrderList.addAll([
    //   OrderInfo(
    //     id: 1,
    //     name: "ElectriQ 60cm 4 Zone Induction Hob",
    //     sku: "DCK1234",
    //     image: "https://via.placeholder.com/150",
    //     availableQty: 1000,
    //     projectName: "DCK Northumberland",
    //     userName: "Alex Novok +2",
    //     price: 2500.00,
    //     qty: 5,
    //   ),
    //   OrderInfo(
    //     id: 2,
    //     name: "Twfydord Alcona Close Coupled Toilet Pan",
    //     sku: "DCK1234",
    //     image: "https://samplelib.com/lib/preview/png/sample-boat-400x300.png",
    //     availableQty: 5,
    //     projectName: "DCK Northumberland",
    //     userName: "Alex Novok +2",
    //     price: 43.21,
    //     qty: 1,
    //   ),
    //   OrderInfo(
    //     id: 2,
    //     name: "Twfydord Alcona Close Coupled Toilet Pan",
    //     sku: "DCK1234",
    //     image: "https://samplelib.com/lib/preview/png/sample-boat-400x300.png",
    //     availableQty: 5,
    //     projectName: "DCK Northumberland",
    //     userName: "Alex Novok +2",
    //     price: 43.21,
    //     qty: 1,
    //   ),
    //   OrderInfo(
    //     id: 2,
    //     name: "Twfydord Alcona Close Coupled Toilet Pan",
    //     sku: "DCK1234",
    //     image: "https://samplelib.com/lib/preview/png/sample-boat-400x300.png",
    //     availableQty: 5,
    //     projectName: "DCK Northumberland",
    //     userName: "Alex Novok +2",
    //     price: 43.21,
    //     qty: 1,
    //   ),
    //   OrderInfo(
    //     id: 2,
    //     name: "Twfydord Alcona Close Coupled Toilet Pan",
    //     sku: "DCK1234",
    //     image: "https://samplelib.com/lib/preview/png/sample-boat-400x300.png",
    //     availableQty: 5,
    //     projectName: "DCK Northumberland",
    //     userName: "Alex Novok +2",
    //     price: 43.21,
    //     qty: 1,
    //   ),
    // ]);
    // buyerOrdersList.value = tempBuyerOrderList;
  }

  void getSuppliersApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.getSuppliers(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          DropdownListResponse response =
              DropdownListResponse.fromJson(jsonDecode(responseModel.result!));
          listSuppliers.addAll(response.info!);
          getStoresApi();
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

  void getStoresApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.getStores(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          DropdownListResponse response =
              DropdownListResponse.fromJson(jsonDecode(responseModel.result!));
          listStores.addAll(response.info!);
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

  bool valid() {
    return formKey.currentState!.validate();
  }

  onClickCreateOrder(bool isDraft) {
    if (valid()) {
      var productList = <ProductRequestInfo>[];
      for (var item in buyerOrdersList) {
        if ((item.cartQty ?? 0) > 0) {
          ProductRequestInfo info = ProductRequestInfo();
          info.productId = item.id ?? 0;
          info.qty = item.cartQty ?? 0;
          info.price = item.price ?? "";
          productList.add(info);
        }
      }
      if (productList.isNotEmpty) {
        createBuyerOrderApi(isDraft, productList);
      } else {
        AppUtils.showToastMessage('msg_add_at_least_one_qty'.tr);
      }
    }
  }

  void createBuyerOrderApi(bool isDraft, List<ProductRequestInfo> productList) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["order_id"] = StringHelper.getText(orderIdController.value);
    map["company_id"] = ApiConstants.companyId;
    map["store_id"] = storeId;
    map["supplier_id"] = supplierId;

    // map["received_by"] =;
    // map["date"] =;
    map["ref"] = StringHelper.getText(refController.value);
    map["note"] = StringHelper.getText(noteController.value);
    map["tax"] = (uniteTotal.value * 0.2).toString();
    map["total_amount"] = (uniteTotal.value * 1.2).toString();
    map["expected_delivery_date"] =
        StringHelper.getText(expectedDeliveryController.value);
    map["checked_product"] = isCheckedProduct.value;
    map["product_data"] = productList;
    print(jsonEncode(productList));
    map["is_draft"] = isDraft;

    _api.createBuyerOrder(
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

  void showSelectStoreDialog() {
    if (listStores.isNotEmpty) {
      showDropDownDialog(
          AppConstants.action.selectStoreDialog, 'store'.tr, listStores, this);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showSelectSupplierDialog() {
    if (listSuppliers.isNotEmpty) {
      showDropDownDialog(AppConstants.action.selectSupplierDialog,
          'supplier'.tr, listSuppliers, this);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        DropDownListDialog(
          title: title,
          dialogType: dialogType,
          list: list,
          listener: listener,
          isCloseEnable: true,
          isSearchEnable: true,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.action.selectStoreDialog) {
      storeController.value.text = name;
      storeId = id;
    } else if (action == AppConstants.action.selectSupplierDialog) {
      supplierController.value.text = name;
      supplierId = id;
    }
  }

  void increaseQty(int index) {
    // if (buyerOrdersList[index].cartQty < buyerOrdersList[index].availableQty) {
    buyerOrdersList[index].cartQty = (buyerOrdersList[index].cartQty ?? 0) + 1;
    buyerOrdersList.refresh();
    // }
    calculateTotalAmount();
  }

  void decreaseQty(int index) {
    if ((buyerOrdersList[index].cartQty ?? 0) > 0) {
      buyerOrdersList[index].cartQty =
          (buyerOrdersList[index].cartQty ?? 0) - 1;
      // buyerOrdersList[index].cartQty--;
      buyerOrdersList.refresh();
    }
    calculateTotalAmount();
  }

  void removeItem(int index) {
    selectedIndex = index;
    showDeleteDialog();
  }

  void onItemClick(int index) {}

  void setQty(int index, int qty) {
    final item = buyerOrdersList[index];

    int finalQty;

    if (qty < 1) {
      finalQty = 0;
    } else if (qty > (item.qty ?? 0)) {
      finalQty = item.qty ?? 0;
    } else {
      finalQty = qty;
    }

    item.cartQty = finalQty;
    buyerOrdersList.refresh();
  }

  Future<void> searchItem(String value) async {
    List<ProductInfo> results = [];
    if (value.isEmpty) {
      results = tempBuyerOrderList;
    } else {
      results = tempBuyerOrderList
          .where((element) => (!StringHelper.isEmptyString(element.name) &&
              element.name!.toLowerCase().contains(value.toLowerCase())))
          .toList();
    }
    buyerOrdersList.value = results;
  }

  void clearSearch() {
    searchController.value.clear();
    searchItem("");
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
      buyerOrdersList.removeAt(selectedIndex);
    }
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

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
      expectedDeliveryDate = date;
      expectedDeliveryController.value.text =
          DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_DASH);
    }
  }

  void calculateTotalAmount() {
    uniteTotal.value = 0;
    for (var item in buyerOrdersList) {
      uniteTotal.value = uniteTotal.value +
          ((double.parse(item.price ?? "0")) * (item.cartQty ?? 0));
    }
  }
}
