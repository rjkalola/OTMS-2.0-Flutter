import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/health_and_safety_service.dart';
import 'package:get/get.dart';

class HealthAndSafetyController extends GetxController{

  bool isDataUpdated = false;

  @override
  void onInit() {
    super.onInit();
    Get.put(HealthAndSafetyService());
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