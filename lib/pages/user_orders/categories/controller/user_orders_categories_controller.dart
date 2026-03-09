import 'dart:convert';
import 'package:belcka/pages/user_orders/categories/controller/user_orders_categories_repository.dart';
import 'package:belcka/pages/user_orders/categories/model/user_orders_categories_info.dart';
import 'package:belcka/pages/user_orders/categories/model/user_orders_categories_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserOrdersCategoriesController extends GetxController{
  RxBool isDeliverySelected = true.obs;
  final _api = UserOrdersCategoriesRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;

  RxList<UserOrdersCategoriesInfo> categoriesList = <UserOrdersCategoriesInfo>[].obs;
  List<UserOrdersCategoriesInfo> tempList = [];

  final searchController = TextEditingController().obs;
  RxInt cartCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getCategoriesListApi();
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
          UserOrdersCategoriesResponse.fromJson(jsonDecode(responseModel.result!));
          tempList.clear();
          tempList.addAll(response.info ?? []);
          categoriesList.value = tempList;
          categoriesList.refresh();
          updateCartCount(response.cartProductCount ?? 0);
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
    cartCount.value = count;
  }
  Future<void> moveToScreen(String rout, dynamic arguments) async {
    clearSearch();
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      getCategoriesListApi();
    }
  }

  Future<void> searchItem(String value) async {
    print(value);
    List<UserOrdersCategoriesInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) =>
      (!StringHelper.isEmptyString(element.name) &&
          element.name!
              .toLowerCase()
              .contains(value.toLowerCase())))
          .toList();
    }
    categoriesList.value = results;
  }
  void clearSearch() {
    searchController.value.clear();
    searchItem("");
    isSearchEnable.value = false;
  }
}