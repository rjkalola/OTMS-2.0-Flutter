import 'package:belcka/pages/user_orders/order_history/controller/order_history_repository.dart';
import 'package:get/get.dart';

class OrderHistoryController extends GetxController{
  RxBool isDeliverySelected = true.obs;
  final _api = OrderHistoryRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;
}