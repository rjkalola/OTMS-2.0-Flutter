import 'package:belcka/pages/user_orders/product_details/controller/product_details_repository.dart';
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

  @override
  void onInit() {
    super.onInit();
    isMainViewVisible.value = true;
  }
}
