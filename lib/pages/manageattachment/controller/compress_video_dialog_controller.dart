import 'package:belcka/res/colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CompressVideoDialogController extends GetxController {
  final RxBool isShowing = false.obs;

  void show({
    String title = "Please wait",
    String message = "Loading...",
    Widget? content,
    bool dismissible = false,
  }) {
    if (isShowing.value) return;

    isShowing.value = true;

    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor:  backgroundColor_(Get.context!),
          // title: Text(title),
          content: content ?? Text(message),
        ),
      ),
      barrierDismissible: dismissible,
    );
  }

  void hide() {
    if (!isShowing.value) return;

    isShowing.value = false;
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
