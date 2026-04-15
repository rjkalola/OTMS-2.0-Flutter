import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/health_and_safety_service.dart';
import 'package:get/get.dart';

class HsSettingsController extends GetxController{
  bool isDataUpdated = false;

  @override
  void onInit() {
    super.onInit();

  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {

    }
  }

  void onBackPress() {
    Get.back(result: isDataUpdated);
  }
}