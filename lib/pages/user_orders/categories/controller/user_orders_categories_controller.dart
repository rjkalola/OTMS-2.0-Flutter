import 'dart:convert';
import 'package:belcka/pages/user_orders/categories/controller/user_orders_categories_repository.dart';
import 'package:belcka/pages/user_orders/categories/model/user_orders_categories_info.dart';
import 'package:belcka/pages/user_orders/categories/model/user_orders_categories_response.dart';
import 'package:belcka/utils/app_utils.dart';
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

  final searchController = TextEditingController().obs;
  final categoriesList = <UserOrdersCategoriesInfo>[].obs;
  List<UserOrdersCategoriesInfo> tempList = [];

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

}