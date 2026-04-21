import 'package:get/get.dart';

class ScoreMoreDetailsController extends GetxController {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  int userScore = 0;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      userScore = arguments["score"] ?? 0;
    }
    isMainViewVisible.value = true;
  }
}
