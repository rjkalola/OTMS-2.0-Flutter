import 'package:belcka/pages/user_orders/product_info/controller/product_info_repository.dart';
import 'package:get/get.dart';

class ProductInfoController extends GetxController{
  RxBool isDeliverySelected = true.obs;
  final _api = ProductInfoRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs;

  @override
  void onInit() {
    super.onInit();

  }
}