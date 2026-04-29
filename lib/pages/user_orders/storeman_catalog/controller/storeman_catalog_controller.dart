import 'dart:convert';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/timesheet/time_sheet_filter/view/widgets/categories_list.dart';
import 'package:belcka/pages/user_orders/categories/model/user_orders_categories_info.dart';
import 'package:belcka/pages/user_orders/categories/model/user_orders_categories_response.dart';
import 'package:belcka/pages/user_orders/product_set/model/product_set_data_info.dart';
import 'package:belcka/pages/user_orders/product_set/model/product_set_data_response.dart';
import 'package:belcka/pages/user_orders/product_set/model/product_set_info.dart';
import 'package:belcka/pages/user_orders/product_set/model/product_set_response.dart';
import 'package:belcka/pages/user_orders/project_service/project_service.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_repository.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_categories.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/add_to_cart_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/get_products_response.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_response_model.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class StoremanCatalogController extends GetxController {
  RxBool isDeliverySelected = true.obs;
  final _api = StoremanCatalogRepository();
  RxBool isLoading = false.obs,
      isProductsLoading = false.obs,
      isLoadingMore = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs,
      isRightSideListEnable = true.obs,
      isResetEnable = false.obs;

  /*
  final products = <ProductInfo>[].obs;
  List<ProductInfo> tempList = [];
  */

  final categories = <ProductCategories>[].obs;
  List<ProductCategories> tempList = [];

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

  var currentPage = 1.obs;
  int limit = 20;
  var hasMoreData = true.obs;
  final ScrollController scrollController = ScrollController();

  List<FocusNode> qtyFocusNodes = [];

  List<ProductSetDataInfo> productsSetList = [];
  RxBool isGridViewSelected = false.obs;

  void initFocusNodes(int length) {
    qtyFocusNodes = List.generate(length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var category in categories) {
      for (var product in category.products) {
        product.qtyFocusNode.dispose();
      }
    }
    scrollController.dispose();
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

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        if (!isLoading.value && hasMoreData.value) {
          fetchProducts();
        }
      }
    });

    Get.put(ProjectService());
  }

  void selectCategory(int selectedID) {
    FocusManager.instance.primaryFocus?.unfocus();
    activeCategoryId.value = selectedID;
    fetchProducts(isRefresh: true);
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

  Future<void> onReorderCategory(int oldIndex, int newIndex) async {
    final list = List<UserOrdersCategoriesInfo>.from(categoriesList);
    final movedItem = list.removeAt(oldIndex);
    list.insert(newIndex, movedItem);
    categoriesList.value = list;
    tempCategoryList = List<UserOrdersCategoriesInfo>.from(list);
    changeCategoriesBulkSequenceApi();
  }

  void changeCategoriesBulkSequenceApi() {
    Map<String, dynamic> map = {};
    map["user_id"] = UserUtils.getLoginUserId();
    map["company_id"] = ApiConstants.companyId;
    map["sequence"] = List.generate(
      categoriesList.length,
      (index) => {
        "id": categoriesList[index].id ?? 0,
        "new_position": index + 1,
      },
    );
    _api.changeCategoriesBulkSequenceAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (!responseModel.isSuccess &&
            !StringHelper.isEmptyString(responseModel.statusMessage)) {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
      },
      onError: (ResponseModel error) {
        if (error.statusCode != ApiConstants.CODE_NO_INTERNET_CONNECTION &&
            error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
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

          fetchProducts(isRefresh: true);

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

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
    }

    if (!hasMoreData.value && !isRefresh) return;

    isLoading.value = true;

    if (currentPage.value == 1) {
      isProductsLoading.value = true;
    }
    else{
      isLoadingMore.value = true;
    }

    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["page"] = currentPage.value;
    map["limit"] = limit;

    if (activeCategoryId.value > 0) {
      map["category_ids"] = activeCategoryId.value;
      isResetEnable.value = true;
    }

    _api.getProductsAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          ProductResponseModel response =
          ProductResponseModel.fromJson(jsonDecode(responseModel.result!));
          var newItems = response.info;

          if (isRefresh) {
            tempList.clear();
          }

          if (response.pagination != null) {
            if (currentPage.value >= response.pagination!.totalPages) {
              hasMoreData.value = false;
            } else {
              currentPage.value++;
            }
          }

          tempList.addAll(newItems);
          categories.value = List.from(tempList);

          prepareProductImages();
          categories.refresh();

          updateCartCount(response.cartProduct);
          isMainViewVisible.value = true;

        }
        else{
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isProductsLoading.value = false;
        isLoadingMore.value = false;
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isProductsLoading.value = false;
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

  void _prepareSingleProductImages(ProductInfo product) {
    product.productImages ??= [];

    final exists = product.productImages!.any(
      (img) => img.imageUrl == product.imageUrl,
    );

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

  void prepareProductImages() {
    for (var category in categories) {
      for (var product in category.products ?? []) {
        _prepareSingleProductImages(product);
      }
    }
  }

  void toggleBookmark(int index, ProductCategories category, int folderId) {
    //isLoading.value = true;
    final product = category.products[index];
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = product.id;
    map["folder_id"] = folderId;

    _api.bookmarkAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
           fetchProducts(isRefresh: true);
        }else{
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

  void toggleAddToCart(
      int index, int cartQuantity, ProductCategories category) {
    isLoading.value = true;
    final product = category.products[index];
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
          if (response.info != null && response.info!.isNotEmpty) {
            AddToCartInfo cartInfo = response.info![0];
            product.cartId = cartInfo.id ?? 0;
            // product.cartQty = (cartInfo.qty ?? cartQuantity).toDouble();
            product.isCartProduct = true;
            categories.refresh();
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
            fetchProducts(isRefresh: true);
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

  void toggleRemoveCart(int index, ProductCategories category) {
    isLoading.value = true;
    final product = category.products[index];
    Map<String, dynamic> map = {};
    map["id"] = product.cartId;
    _api.removeFromCartAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess) {
          AddToCartResponse response = AddToCartResponse.fromJson(
              jsonDecode(responseModel.result!) as Map<String, dynamic>);
            product.cartId = 0;
            product.cartQty = 0;
            product.isCartProduct = false;
            categories.refresh();
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

  void increaseQty(int index, ProductCategories category) {
    final product = category.products[index];
    double userQty = (product.cartQty ?? 0.0) + 1;
    product.cartQty = userQty;
    categories.refresh();
  }

  void decreaseQty(int index, ProductCategories category) {
    final product = category.products[index];
    double userQty = product.cartQty ?? 0.0;
    if (userQty <= 1) return;
    product.cartQty = userQty - 1;
    categories.refresh();
  }

  void decrementOrRemoveFromCart(int index, ProductCategories category) {
    final product = category.products[index];
    final currentQty = (product.cartQty ?? 0).toInt();
    if (currentQty <= 1) {
      toggleRemoveCart(index, category);
      return;
    }
    decreaseQty(index, category);
    final newQty = (category.products[index].cartQty ?? 0).toInt();
    toggleAddToCart(index, newQty, category);
  }

  void updateCartCount(int count) {
    cartCount.value = count;
  }

  void updateSubQty(int index, int count, ProductCategories category) {
    final product = category.products[index];
    product.cartQty = count.toDouble();
    categories.refresh();
  }

  void onBackPress() {
    Get.back(result: isDataUpdated);
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    clearSearch();
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      fetchProducts(isRefresh: true);
    }
  }

  Future<void> searchItem(String value) async {
    if (value.isEmpty) {
      categories.value = List.from(tempList);
      return;
    }

    final query = value.toLowerCase();

    List<ProductCategories> filteredCategories = [];

    for (var category in tempList) {
      final filteredProducts = (category.products ?? []).where((product) {
        final nameMatch =
            (product.shortName ?? "").toLowerCase().contains(query);

        final uuidMatch = (product.uuid ?? "").toLowerCase().contains(query);

        return nameMatch || uuidMatch;
      }).toList();

      // Only add category if it has matching products
      if (filteredProducts.isNotEmpty) {
        filteredCategories.add(
          category.copyWith(products: filteredProducts),
        );
      }
    }

    categories.value = filteredCategories;
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

  int getGlobalIndex(int catIndex, int productIndex) {
    int index = 0;
    for (int i = 0; i < catIndex; i++) {
      index += categories[i].products.length;
    }
    return index + productIndex;
  }
}
