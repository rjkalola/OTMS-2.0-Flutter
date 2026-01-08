import 'package:belcka/buyer_app/purchasing/controller/purchasing_repository.dart';
import 'package:get/get.dart';

class PurchasingController extends GetxController {
  final _api = PurchasingRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  double cardRadius = 12;

  @override
  void onInit() {
    super.onInit();
  }
}
