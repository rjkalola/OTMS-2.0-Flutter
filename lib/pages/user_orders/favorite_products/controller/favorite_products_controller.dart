import 'dart:convert';
import 'package:belcka/buyer_app/create_buyer_order/controller/create_buyer_order_repository.dart';
import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/common/model/Dropdown_list_response.dart';
import 'package:belcka/pages/project/address_list/controller/address_list_repository.dart';
import 'package:belcka/pages/project/address_list/model/address_info.dart';
import 'package:belcka/pages/project/address_list/model/address_list_response.dart';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/pages/project/project_info/model/project_list_response.dart';
import 'package:belcka/pages/project/project_list/view/active_project_dialog.dart';
import 'package:belcka/pages/user_orders/basket/controller/basket_repository.dart';
import 'package:belcka/pages/user_orders/basket/model/product_cart_list_response.dart';
import 'package:belcka/pages/user_orders/favorite_products/controller/favorites_products_repository.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/pages/user_orders/widgets/select_address_dialog.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
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

  final Map<int, int> currentImageIndex = {};
  bool isDataUpdated = false;
  int projectId = 0;

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
      projectId = arguments["project_id"] ?? "";
    }
    fetchBookmarkList();
  }

  void fetchBookmarkList() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["project_id"] = projectId;

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

  void toggleRemoveCart(int index) {
    isLoading.value = true;
    final product = bookmarkList[index];
    Map<String, dynamic> map = {};
    map["id"] = product.id;
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
    final current = (product.cartQty ?? 0).toInt();
    if (current <= 1) {
      toggleRemoveCart(index);
      return;
    }
    decreaseQty(index);
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
