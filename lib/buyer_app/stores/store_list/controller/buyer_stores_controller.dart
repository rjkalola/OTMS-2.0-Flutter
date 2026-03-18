import 'dart:convert';

import 'package:belcka/buyer_app/project_list/controller/buyer_projects_repository.dart';
import 'package:belcka/buyer_app/purchasing/controller/purchasing_repository.dart';
import 'package:belcka/buyer_app/purchasing/model/buyer_order_dashboard_response.dart';
import 'package:belcka/buyer_app/stores/store_list/controller/buyer_store_repository.dart';
import 'package:belcka/buyer_app/stores/store_list/models/store_info.dart';
import 'package:belcka/buyer_app/stores/store_list/models/store_list_response.dart';
import 'package:belcka/pages/common/model/Dropdown_list_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';

class BuyerStoresController extends GetxController {
  final _api = BuyerStoreRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  double cardRadius = 12;
  final listItems = <StoreInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    buyerStoresListApi(true);
  }

  void buyerStoresListApi(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.buyerStoresList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          StoreListResponse response =
          StoreListResponse.fromJson(jsonDecode(responseModel.result!));
          listItems.value = response.info!;
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

  Future<void> moveToScreen(
      {required String appRout, dynamic arguments}) async {
    var result = await Get.toNamed(appRout, arguments: arguments);
    if (result != null && result) {
      buyerStoresListApi(true);
    }
  }

  void onBackPress() {
    Get.back(result: true);
  }
}
