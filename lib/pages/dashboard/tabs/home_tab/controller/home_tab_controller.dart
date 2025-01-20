import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_repository.dart';

class HomeTabController extends GetxController {
  final _api = HomeTabRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    // getRegisterResources();
  }
}
