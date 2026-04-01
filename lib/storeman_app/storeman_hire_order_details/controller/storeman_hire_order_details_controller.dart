import 'dart:convert';

import 'package:belcka/pages/user_orders/hire_module/user_hire_order_details/model/hire_order_detail_response.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_products/model/hire_order_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/storeman_app/storeman_hire_order_details/controller/storeman_hire_order_details_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class StoremanHireOrderDetailsController extends GetxController {
  final _api = StoremanHireOrderDetailsRepository();

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;

  final orderInfo = HireOrderInfo().obs;
  final productsList = <ProductInfo>[].obs;

  int _orderId = 0;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      _orderId = arguments[AppConstants.intentKey.orderId] ?? 0;
    }
    if (_orderId > 0) {
      loadDetail();
    } else {
      AppUtils.showSnackBarMessage('empty_data_message'.tr);
    }
  }

  void loadDetail() {
    isLoading.value = true;
    _api.getHireOrderDetail(
      queryParameters: {
        'company_id': ApiConstants.companyId,
        'id': _orderId,
      },
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          final response = HireOrderDetailResponse.fromJson(
              jsonDecode(responseModel.result!));
          orderInfo.value = response.info ?? HireOrderInfo();
          productsList.assignAll(orderInfo.value.products ?? []);
          isMainViewVisible.value = true;
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? '');
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? '');
        }
      },
    );
  }

  void onBackPress() {
    Get.back();
  }
}
