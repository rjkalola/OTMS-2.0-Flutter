import 'package:get/get.dart';

class SettingsController extends GetxController {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void moveToScreen(String appRout) {
    Get.toNamed(appRout);
  }
}
