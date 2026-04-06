import 'package:belcka/pages/user_orders/project_service/project_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FavoritesController extends GetxController {

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs,
      isRightSideListEnable = true.obs,
      isResetEnable = false.obs;

  bool isDataUpdated = false;
  final projectService = Get.find<ProjectService>();

  @override
  void onInit() {
    super.onInit();
    isMainViewVisible.value = true;
  }

  void onBackPress() {
    Get.back(result: isDataUpdated);
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated = true;
    }
  }
}