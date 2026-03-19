import 'dart:convert';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/user_orders/product_details/controller/product_details_repository.dart';
import 'package:belcka/pages/user_orders/product_details/model/product_details_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/add_to_cart_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  final _api = ProductDetailsRepository();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final currentImageIndex = <int, int>{}.obs;

  int productId = 0;
  final product = ProductInfo().obs;
  bool isDataUpdated = false;
  RxInt cartCount = 0.obs;

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
          ProductDetailsResponse response = ProductDetailsResponse.fromJson(
              jsonDecode(responseModel.result!));
          if (response.info != null) {
            product.value = response.info!;
            prepareProductImages();
          }
          isMainViewVisible.value = true;
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

  void prepareProductImages() {
    if (product.value.productImages == null) {
      product.value.productImages = [];
    }

    final exists = product.value.productImages!
        .any((img) => img.imageUrl == product.value.imageUrl);
    if (!exists) {
      product.value.productImages!.insert(
        0,
        FilesInfo(
          id: 0,
          imageUrl: product.value.imageUrl,
          thumbUrl: product.value.thumbUrl,
        ),
      );
    }
  }

  void toggleAddToCart(int cartQuantity) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = product.value.id;
    map["qty"] = product.value.qty;
    map["cart_qty"] = cartQuantity;
    map["is_sub_qty"] = (product.value.isSubQty ?? false) ? 1 : 0;

    _api.addToCartAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          AddToCartResponse response = AddToCartResponse.fromJson(
              jsonDecode(responseModel.result!) as Map<String, dynamic>);
          if (response.info != null) {
            product.value.cartId = response.info!.id;
            product.value.isCartProduct = true;
            product.refresh();
          }
          updateCartCount(response.cartProduct ?? 0);
          isDataUpdated = true;
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

  void toggleRemoveCart() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = product.value.cartId;
    _api.removeFromCartAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess && responseModel.result != null) {
          try {
            AddToCartResponse response = AddToCartResponse.fromJson(
                jsonDecode(responseModel.result!) as Map<String, dynamic>);
            product.value.cartId = 0;
            product.value.isCartProduct = false;
            product.refresh();
            updateCartCount(response.cartProduct ?? 0);
          } catch (_) {
            product.value.cartId = 0;
            product.value.isCartProduct = false;
            product.refresh();
          }
          isDataUpdated = true;
        } else {
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

  void updateCartCount(int count) {
    cartCount.value = count;
  }

  void toggleBookmark() {
    // isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = product.value.id;

    _api.bookmarkAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isDataUpdated = true;
          // fetchProductDetails();
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

  void increaseQty() {
    double userQty = (product.value.cartQty ?? 0) + 1;
    product.value.cartQty = userQty;
    product.refresh();
    toggleAddToCart((product.value.cartQty ?? 0).toInt());
  }

  void decreaseQty() {
    double userQty = product.value.cartQty ?? 0;
    if (userQty == 0 || userQty == 1) return;
    product.value.cartQty = userQty - 1;
    product.refresh();
    toggleAddToCart((product.value.cartQty ?? 0).toInt());
  }

  void updateSubQty(int count) {
    product.value.cartQty = count.toDouble();
    product.refresh();
  }

  void setCurrentImageIndex(int index, int page) {
    currentImageIndex[index] = page;
    currentImageIndex.refresh();
  }

  void onBackPress() {
    Get.back(result: isDataUpdated);
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated = result;
      fetchProductDetails();
    }
  }
}
