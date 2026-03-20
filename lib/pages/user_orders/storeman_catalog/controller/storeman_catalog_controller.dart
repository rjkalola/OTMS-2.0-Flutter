import 'dart:convert';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/user_orders/categories/model/user_orders_categories_info.dart';
import 'package:belcka/pages/user_orders/categories/model/user_orders_categories_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_repository.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/add_to_cart_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/get_products_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class StoremanCatalogController extends GetxController {
  RxBool isDeliverySelected = true.obs;
  final _api = StoremanCatalogRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs,
      isRightSideListEnable = true.obs,
      isResetEnable = false.obs;

  final List<IconData> sideIcons = const [
    Icons.expand,
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

  final products = <ProductInfo>[].obs;
  List<ProductInfo> tempList = [];

  int categoryIds = 0;
  final currentImageIndex = <int, int>{}.obs;

  RxInt cartCount = 0.obs;
  bool isDataUpdated = false;

  final searchController = TextEditingController().obs;

  RxList<UserOrdersCategoriesInfo> categoriesList =
      <UserOrdersCategoriesInfo>[].obs;
  List<UserOrdersCategoriesInfo> tempCategoryList = [];

  RxInt activeCategoryId = 0.obs;
  RxBool isCategoryExpanded = false.obs;

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
      categoryIds = arguments["category_ids"] ?? 0;
    }
    getCategoriesListApi();
  }

  void selectCategory(int selectedID) {
    FocusManager.instance.primaryFocus?.unfocus();
    activeCategoryId.value = selectedID;
    fetchProducts();
  }

  void toggleCategoryGrid() {
    FocusManager.instance.primaryFocus?.unfocus();
    isCategoryExpanded.toggle();
    clearSearch();
    isSearchEnable.value = false;
  }

  void selectCategoryFromGrid(int selectedID) {
    FocusManager.instance.primaryFocus?.unfocus();
    isCategoryExpanded.value = false;
    selectCategory(selectedID);
  }

  void getCategoriesListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.getCategoriesList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          UserOrdersCategoriesResponse response =
              UserOrdersCategoriesResponse.fromJson(
                  jsonDecode(responseModel.result!));
          tempCategoryList.clear();
          tempCategoryList.addAll(response.info ?? []);

          categoriesList.value = tempCategoryList;
          categoriesList.refresh();

          fetchProducts();

          updateCartCount(response.cartProductCount ?? 0);
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

  void fetchProducts() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    if (activeCategoryId.value > 0) {
      map["category_ids"] = activeCategoryId.value;
      isResetEnable.value = true;
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
          prepareProductImages();
          products.refresh();
          updateCartCount(response.cartProduct ?? 0);
          isMainViewVisible.value = true;
          initFocusNodes(products.length);
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
    for (var product in products) {
      if (product.productImages == null) {
        product.productImages = [];
      }

      final exists =
          product.productImages!.any((img) => img.imageUrl == product.imageUrl);
      if (!exists) {
        product.productImages!.insert(
          0,
          FilesInfo(
            id: 0,
            imageUrl: product.imageUrl,
            thumbUrl: product.thumbUrl,
          ),
        );
      }
    }
  }

  void toggleBookmark(int index) {
    // isLoading.value = true;
    final product = products[index];
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = product.id;

    _api.bookmarkAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          // fetchProducts();
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
    final product = products[index];
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = product.id;
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
            product.cartId = response.info!.id;
            // product.cartQty = (response.info!.qty ?? 0).toDouble();
            product.isCartProduct = true;
            products.refresh();
          }
          updateCartCount(response.cartProduct ?? 0);
          // AppUtils.showApiResponseMessage(response.message ?? "");
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
    final product = products[index];
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
            product.cartId = 0;
            // product.cartQty = (response.info!.qty ?? 0).toDouble();
            product.isCartProduct = false;
            products.refresh();
          }
          updateCartCount(response.cartProduct ?? 0);
          // AppUtils.showApiResponseMessage(response.message ?? "");
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

  void setCurrentImageIndex(int index, int page) {
    currentImageIndex[index] = page;
    currentImageIndex.refresh();
  }

  void increaseQty(int index) {
    final product = products[index];
    double userQty = (product.cartQty ?? 0.0) + 1;
    product.cartQty = userQty;
    products.refresh();
  }

  void decreaseQty(int index) {
    final product = products[index];
    double userQty = product.cartQty ?? 0.0;
    if (userQty == 0 || userQty == 1) return;
    product.cartQty = userQty - 1;
    products.refresh();
  }

  void updateCartCount(int count) {
    cartCount.value = count;
  }

  void updateSubQty(int index, int count) {
    final product = products[index];
    product.cartQty = count.toDouble();
    products.refresh();
  }

  void onBackPress() {
    Get.back(result: isDataUpdated);
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    clearSearch();
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      fetchProducts();
    }
  }

  Future<void> searchItem(String value) async {
    List<ProductInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) =>
              (!StringHelper.isEmptyString(element.shortName) &&
                  element.shortName!
                      .toLowerCase()
                      .contains(value.toLowerCase())) ||
              (!StringHelper.isEmptyString(element.uuid) &&
                  element.uuid!.toLowerCase().contains(value.toLowerCase())))
          .toList();
    }
    products.value = results;
  }

  void clearSearch() {
    searchController.value.clear();
    searchItem("");
    isSearchEnable.value = false;
  }

  void clearFilter() {
    isResetEnable.value = false;
    selectCategory(0);
  }
}
