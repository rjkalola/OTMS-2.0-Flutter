import 'dart:convert';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/user_orders/basket/model/product_cart_list_response.dart';
import 'package:belcka/pages/user_orders/favorite_products/controller/favorites_products_repository.dart';
import 'package:belcka/pages/user_orders/product_set/model/product_set_data_info.dart';
import 'package:belcka/pages/user_orders/product_set/model/product_set_data_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/add_to_cart_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoriteProductsController extends GetxController{
  RxBool isDeliverySelected = true.obs;
  final _api = FavoritesProductsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;

  final bookmarkList = <ProductInfo>[].obs;
  List<ProductInfo> tempList = [];

  final currentImageIndex = <int, int>{}.obs;
  bool isDataUpdated = false;
  int folderId = 0;
  List<ProductSetDataInfo> productsSetList = [];

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
      folderId = arguments["id"] ?? "";
    }
    fetchBookmarkList();
  }

  void fetchBookmarkList() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["folder_id"] = folderId;

    _api.getBookmarkListAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          ProductCartListResponse response = ProductCartListResponse.fromJson(
              jsonDecode(responseModel.result!));
          tempList.clear();
          tempList.addAll(response.info ?? []);
          bookmarkList.value = tempList;
          prepareProductImages();
          bookmarkList.refresh();
          isMainViewVisible.value = true;
          isLoading.value = false;
          initFocusNodes(bookmarkList.length);
        } else {
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

  void prepareProductImages() {
    for (var product in bookmarkList) {
      if (product.productImages == null) {
        product.productImages = [];
      }

      final exists = product.productImages!
          .any((img) => img.imageUrl == product.productImage);
      if (!exists) {
        product.productImages!.insert(
          0,
          FilesInfo(
            id: 0,
            imageUrl: product.productImage,
            thumbUrl: product.productThumbImage,
          ),
        );
      }
    }
  }

  void toggleAddToCart(
      int index, int cartQuantity) {
    isLoading.value = true;

    final product = bookmarkList[index];
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = product.productId ?? 0;
    map["qty"] = product.qty ?? 0;
    map["cart_qty"] = cartQuantity;
    map["is_sub_qty"] = (product.isSubQty ?? false) ? 1 : 0;

    _api.addToCartAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          AddToCartResponse response = AddToCartResponse.fromJson(
              jsonDecode(responseModel.result!) as Map<String, dynamic>);
          if (response.info != null && response.info!.isNotEmpty) {
            fetchBookmarkList();
          }
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

  void toggleRemoveCart(int index) {
    isLoading.value = true;
    final product = bookmarkList[index];
    Map<String, dynamic> map = {};
    map["id"] = product.cartId;
    _api.removeFromCartAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isDataUpdated = true;
          fetchBookmarkList();
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
    final product = bookmarkList[index];
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = product.productId;
    map["folder_id"] = folderId;

    _api.bookmarkAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isDataUpdated = true;
           fetchBookmarkList();
        }
        else{
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

  Future<void> fetchProductsSet(int productID) async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = productID;

    _api.getProductSetsAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          ProductSetDataResponse response = ProductSetDataResponse.fromJson(
              jsonDecode(responseModel.result!));

          productsSetList = response.info ?? [];

          List<Map<String, dynamic>> productDataList =
          productsSetList.map((product) {
            return {
              "product_id": product.productId,
              "qty": product.qty,
              "cart_qty": 1,
              "is_sub_qty": product.isSubQty ? 1 : 0,
            };
          }).toList();

          addSetProductsToCart(productID, productDataList);
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
  void addSetProductsToCart(
      int productId, List<Map<String, dynamic>> productDataList) {
    isLoading.value = true;
    Map<String, dynamic> request = {
      "company_id": ApiConstants.companyId,
      "product_id": productId,
      "product_data": productDataList,
    };

    _api.addToCartAPI(
      data: request,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          AddToCartResponse response = AddToCartResponse.fromJson(
              jsonDecode(responseModel.result!) as Map<String, dynamic>);
          if (response.info != null) {
            isDataUpdated = true;
            fetchBookmarkList();
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
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void setCurrentImageIndex(int index, int page) {
    currentImageIndex[index] = page;
    currentImageIndex.refresh();
  }

  void increaseQty(int index) {
    final product = bookmarkList[index];
    double userQty = (product.cartQty ?? 0) + 1;
    product.cartQty = userQty;
  }

  void decreaseQty(int index) {
    final product = bookmarkList[index];
    double userQty = product.cartQty ?? 0.0;
    if (userQty <= 1) return;
    product.cartQty = userQty - 1;
  }

  void decrementOrRemoveFromCart(int index) {
    final product = bookmarkList[index];
    final currentQty = (product.cartQty ?? 0).toInt();
    if (currentQty <= 1) {
      toggleRemoveCart(index);
      return;
    }
    decreaseQty(index);
    final newQty = (bookmarkList[index].cartQty ?? 0).toInt();
    toggleAddToCart(index, newQty);
  }

  void updateSubQty(int index, int count) {
    final product = bookmarkList[index];
    product.cartQty = count.toDouble();
  }

  void onBackPress() {
    Get.back(result: isDataUpdated);
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated = result;
      fetchBookmarkList();
    }
  }
}
