import 'dart:convert';

import 'package:belcka/buyer_app/purchasing/controller/purchasing_repository.dart';
import 'package:belcka/buyer_app/purchasing/model/buyer_order_dashboard_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/app_constants.dart';

class PurchasingController extends GetxController {
  final _api = PurchasingRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  double cardRadius = 12;
  final inventoryData = BuyerOrderDashboardResponse().obs;

  @override
  void onInit() {
    super.onInit();
    inventoryOverviewApi();
  }

  void inventoryOverviewApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.inventoryOverviewApi(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          BuyerOrderDashboardResponse response =
              BuyerOrderDashboardResponse.fromJson(
                  jsonDecode(responseModel.result!));
          inventoryData.value = response;
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void onItemClick(String type) {
    var arguments = {
      AppConstants.intentKey.selectedTabType: type,
    };
    moveToScreen(appRout: AppRoutes.buyerOrdersScreen, arguments: arguments);
  }

  Future<void> moveToScreen(
      {required String appRout, dynamic arguments}) async {
    var result = await Get.toNamed(appRout, arguments: arguments);
  }
}
