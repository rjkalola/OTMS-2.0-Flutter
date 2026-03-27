import 'dart:convert';
import 'package:belcka/pages/user_orders/product_set/controller/product_set_repository.dart';
import 'package:belcka/pages/user_orders/product_set/model/product_set_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/add_to_cart_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductSetController extends GetxController{
  RxBool isDeliverySelected = true.obs;
  final _api = ProductSetRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;


  final productsSet = <ProductInfo>[].obs;
  List<ProductInfo> tempList = [];

  int productId = 0;
  bool isDataUpdated = false;


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
      productId = arguments["product_id"] ?? 0;
    }
    fetchProductsSet();
  }

  void fetchProductsSet() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    if (productId > 0) {
      map["product_id"] = productId;
    }

    _api.getProductsSetAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {

           ProductSetResponse response =
           ProductSetResponse.fromJson(jsonDecode(responseModel.result!));

          tempList.clear();
          if (response.info.isNotEmpty){
            tempList.addAll(response.info[0].products ?? []);
            productsSet.value = tempList;
            productsSet.refresh();
          }
           isMainViewVisible.value = true;
           initFocusNodes(productsSet.length);
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

  void toggleBookmark(int index) {
    isLoading.value = true;
    final product = productsSet[index];
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = product.productId;

    _api.bookmarkAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isDataUpdated = true;
           fetchProductsSet();
        } else {
          isLoading.value = false;
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
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

  void toggleAddToCart(int index, int cartQuantity) {
    isLoading.value = true;
    final product = productsSet[index];
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = product.productId;
    map["qty"] = product.qty;
    map["cart_qty"] = cartQuantity;
    map["is_sub_qty"] = (product.isSubQty ?? false) ? 1 : 0;

    _api.addToCartAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          AddToCartResponse response = AddToCartResponse.fromJson(
              jsonDecode(responseModel.result!) as Map<String, dynamic>);
          if (response.info != null) {
            fetchProductsSet();
          }
          isDataUpdated = true;
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

  void toggleRemoveCart(int index) {
    isLoading.value = true;
    final product = productsSet[index];
    Map<String, dynamic> map = {};
    map["id"] = product.cartId;
    _api.removeFromCartAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess) {
          AddToCartResponse response = AddToCartResponse.fromJson(
              jsonDecode(responseModel.result!) as Map<String, dynamic>);
          if (response.info != null) {
            fetchProductsSet();
          }
          isDataUpdated = true;
        } else {
          isLoading.value = false;
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
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

  void updateSubQty(int index, int count) {
    final product = productsSet[index];
    product.cartQty = count.toDouble();
    productsSet.refresh();
  }

  void increaseQty(int index) {
    final product = productsSet[index];
    double userQty = (product.cartQty ?? 0.0) + 1;
    product.cartQty = userQty;
    productsSet.refresh();
  }

  void decreaseQty(int index) {
    final product = productsSet[index];
    double userQty = product.cartQty ?? 0.0;
    if (userQty == 0 || userQty == 1) return;
    product.cartQty = userQty - 1;
    productsSet.refresh();
  }
  void onBackPress() {
    Get.back(result: isDataUpdated);
  }
  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated = result;
      fetchProductsSet();
    }
  }
}