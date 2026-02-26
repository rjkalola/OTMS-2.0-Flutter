import 'dart:convert';
import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_repository.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/get_products_info_model.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/get_products_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class StoremanCatalogController extends GetxController{

  RxBool isDeliverySelected = true.obs;
  final _api = StoremanCatalogRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;

  final List<IconData> sideIcons = const [
    Icons.grid_view,
    Icons.kitchen,
    Icons.chair,
    Icons.light,
    Icons.bathtub,
    Icons.dining,
    Icons.ac_unit,
    Icons.water_drop,
    Icons.wifi,
    Icons.settings,
  ];

  final products = <GetProductsInfoModel>[].obs;
  List<GetProductsInfoModel> tempList = [];

  int categoryIds = 0;
  final Map<int, int> currentImageIndex = {};

  RxInt cartCount = 0.obs;
  bool isDataUpdated = false;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      categoryIds = arguments["category_ids"] ?? 0;
    }
    fetchProducts();
  }

  void fetchProducts() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    if (categoryIds > 0){
      map["category_ids"] = categoryIds;
    }

    _api.getProductsAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          GetProductsResponse response =
          GetProductsResponse.fromJson(jsonDecode(responseModel.result!));

          tempList.clear();
          tempList.addAll(response.info ?? []);

          products.value = tempList;
          products.refresh();

          updateCartCount(response.cartProduct ?? 0);
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

  void toggleBookmark(int index) {
    final product = products[index];
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = product.id;

    _api.bookmarkAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          fetchProducts();
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
  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      fetchProducts();
    }
  }
  void toggleAddToCart(int index) {
    final product = products[index];
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = product.id;
    map["qty"] = product.qty;
    map["cart_qty"] = product.cartQty;
    _api.addToCartAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isDataUpdated = true;
          fetchProducts();
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
    final product = products[index];
    Map<String, dynamic> map = {};
    map["id"] = product.cartId;
    _api.removeFromCartAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isDataUpdated = true;
          fetchProducts();
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
  void increaseQty(int index) {
    final product = products[index];
    int qty = product.qty ?? 0;
    int userQty = (product.cartQty ?? 0) + 1;
    product.cartQty = userQty;
  }
  void decreaseQty(int index) {
    final product = products[index];
    int qty = product.qty ?? 0;
    int userQty = product.cartQty ?? 0;
    if (userQty == 1) return;
    product.cartQty = userQty - 1;
  }

  void updateCartCount(int count) {
    cartCount.value = count;
  }
  void onBackPress() {
    Get.back(result: isDataUpdated);
  }
}