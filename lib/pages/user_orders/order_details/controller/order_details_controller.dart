import 'dart:convert';
import 'package:belcka/pages/user_orders/order_details/controller/order_details_repository.dart';
import 'package:belcka/pages/user_orders/order_details/model/order_details_info.dart';
import 'package:belcka/pages/user_orders/order_details/model/order_details_response.dart';
import 'package:belcka/pages/user_orders/order_history/model/order_history_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class OrderDetailsController extends GetxController{
  RxBool isDeliverySelected = true.obs;
  final _api = OrderDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;
  bool isDataUpdated = false;

  RxList<OrderDetailsInfo> orderDetails = <OrderDetailsInfo>[].obs;
  List<OrderDetailsInfo> tempList = [];
  String orderId = "";

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      orderId = arguments["order_id"] ?? "";
    }
    fetchOrderDetails();
  }
  void fetchOrderDetails() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["id"] = orderId;

    _api.getOrderHistoryAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          OrderDetailsResponse response =
          OrderDetailsResponse.fromJson(jsonDecode(responseModel.result!));

          tempList.clear();
          tempList.addAll(response.info ?? []);

          orderDetails.value = tempList;
          orderDetails.refresh();

          isMainViewVisible.value = true;
          isLoading.value = false;
        }
        else{
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
          isLoading.value = false;
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }
  void onBackPress() {
    Get.back(result: isDataUpdated);
  }
}