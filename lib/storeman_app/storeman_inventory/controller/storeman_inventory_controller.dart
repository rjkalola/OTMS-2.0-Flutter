import 'dart:convert';

import 'package:belcka/storeman_app/storeman_inventory/controller/storeman_inventory_repository.dart';
import 'package:belcka/storeman_app/storeman_inventory/model/storeman_inventory_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/app_constants.dart';

class StoremanInventoryController extends GetxController {
  final _api = StoremanInventoryRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  RxString startDate = "".obs,
      endDate = "".obs,
      displayStartDate = "".obs,
      displayEndDate = "".obs;
  final RxInt selectedDateFilterIndex = (2).obs;
  double cardRadius = 12;
  final inventoryData = StoremanInventoryResponse().obs;

  @override
  void onInit() {
    super.onInit();
    inventoryOverviewApi(true);
  }

  void inventoryOverviewApi(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["start_date"] = startDate.value;
    map["end_date"] = endDate.value;

    _api.inventoryOverviewApi(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          StoremanInventoryResponse response =
              StoremanInventoryResponse.fromJson(
                  jsonDecode(responseModel.result!));
          inventoryData.value = response;
          displayStartDate.value = response.startDate ?? "";
          displayEndDate.value = response.endDate ?? "";
          startDate.value = response.startDate ?? "";
          endDate.value = response.endDate ?? "";
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

  void onInternalOrdersItemClick(String type) {
    var arguments = {
      AppConstants.intentKey.selectedTabType: type,
      AppConstants.intentKey.index: selectedDateFilterIndex.value,
      AppConstants.intentKey.startDate: startDate.value,
      AppConstants.intentKey.endDate: endDate.value,
    };
    moveToScreen(
        appRout: AppRoutes.storemanInternalOrdersScreen, arguments: arguments);
  }

  void onSupplierOrdersItemClick(String type) {
    var arguments = {
      AppConstants.intentKey.selectedTabType: type,
      AppConstants.intentKey.index: selectedDateFilterIndex.value,
      AppConstants.intentKey.startDate: startDate.value,
      AppConstants.intentKey.endDate: endDate.value,
    };
    moveToScreen(
        appRout: AppRoutes.storemanSupplierOrdersScreen, arguments: arguments);
  }

  void onHireItemClick(String type) {
    var arguments = {
      AppConstants.intentKey.selectedTabType: type,
      AppConstants.intentKey.index: selectedDateFilterIndex.value,
      AppConstants.intentKey.startDate: startDate.value,
      AppConstants.intentKey.endDate: endDate.value,
    };
    moveToScreen(
        appRout: AppRoutes.storemanHireProductsScreen, arguments: arguments);
  }

  void onItemClick(String type) {
    var arguments = {
      AppConstants.intentKey.selectedTabType: type,
      AppConstants.intentKey.index: selectedDateFilterIndex.value,
      AppConstants.intentKey.startDate: startDate.value,
      AppConstants.intentKey.endDate: endDate.value,
    };
    moveToScreen(appRout: AppRoutes.buyerOrdersScreen, arguments: arguments);
  }

  Future<void> moveToScreen(
      {required String appRout, dynamic arguments}) async {
    await Get.toNamed(appRout, arguments: arguments);
    inventoryOverviewApi(false);
  }
}
