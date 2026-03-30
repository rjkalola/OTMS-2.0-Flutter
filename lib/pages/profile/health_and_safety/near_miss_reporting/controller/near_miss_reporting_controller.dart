import 'package:belcka/pages/profile/health_and_safety/near_miss_reporting/controller/near_miss_reporting_repository.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NearMissReportingController extends GetxController{
  RxBool isDeliverySelected = true.obs;
  final _api = NearMissReportingRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;

  File? selectedMedia;
  final ImagePicker picker = ImagePicker();


  @override
  void onInit() {
    super.onInit();

  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {

    }
  }
// --- Method to Clear Media (X Button) ---
  void clearMedia() {
    selectedMedia = null;
  }
  void onBackPress() {
    Get.back(result: true);
  }
}