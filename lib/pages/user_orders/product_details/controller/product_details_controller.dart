import 'dart:convert';
import 'package:belcka/pages/user_orders/product_details/controller/product_details_repository.dart';
import 'package:belcka/pages/user_orders/product_details/model/product_details_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController{
  final _api = ProductDetailsRepository();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final Map<int, int> currentImageIndex = {};

  int productId = 0;
  final product = ProductInfo().obs;
  bool isDataUpdated = false;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      productId = arguments["product_id"] ?? 0;
    }
    fetchProductDetails();
  }
  void fetchProductDetails() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = productId;

    _api.getProductDetailsAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          ProductDetailsResponse response =
          ProductDetailsResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.info != null){
            product.value = response.info!;
          }
          isMainViewVisible.value = true;
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
  void toggleAddToCart() {
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = product.value.id;
    map["qty"] = product.value.qty;
    map["cart_qty"] = product.value.cartQty;
    _api.addToCartAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isDataUpdated = true;
          fetchProductDetails();
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
  void toggleRemoveCart() {
    Map<String, dynamic> map = {};
    map["id"] = product.value.cartId;
    _api.removeFromCartAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isDataUpdated = true;
          fetchProductDetails();
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
  void increaseQty() {
    int qty = product.value.qty ?? 0;
    int userQty = (product.value.cartQty ?? 0) + 1;
    product.value.cartQty = userQty;
  }
  void decreaseQty() {
    int qty = product.value.qty ?? 0;
    int userQty = product.value.cartQty ?? 0;
    if (userQty == 0 || userQty == 1) return;
    product.value.cartQty = userQty - 1;
  }
  void toggleBookmark() {
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = product.value.id;

    _api.bookmarkAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isDataUpdated = true;
          fetchProductDetails();
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

  void updateCartCount(int count) {
    //cartCount.value = count;
  }
  void onBackPress() {
    Get.back(result: isDataUpdated);
  }
  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      fetchProductDetails();
    }
  }
}
