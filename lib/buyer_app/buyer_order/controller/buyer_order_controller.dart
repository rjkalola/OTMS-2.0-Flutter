import 'package:belcka/buyer_app/purchasing/controller/purchasing_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BuyerOrderController extends GetxController {
  final _api = PurchasingRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;
  double cardRadius = 12;
  RxString selectedStatusFilter = "request".obs;
  RxInt requestCount = 0.obs, proceedCount = 0.obs, deliveredCount = 0.obs;
  final searchAddressController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
  }
}
