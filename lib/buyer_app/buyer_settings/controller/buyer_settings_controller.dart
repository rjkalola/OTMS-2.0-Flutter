import 'dart:async';

import 'package:belcka/buyer_app/purchasing/model/buyer_order_dashboard_response.dart';
import 'package:belcka/pages/project/project_details/controller/project_details_repository.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:get/get.dart';

class BuyerSettingsController extends GetxController {
  final _api = ProjectDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isDataUpdated = false.obs;
  final listItems = <ModuleInfo>[].obs;
  final settingDetails = BuyerOrderDashboardResponse().obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      settingDetails.value = arguments[AppConstants.intentKey.itemDetails] ??
          BuyerOrderDashboardResponse();
    }
    setListItems();
  }

  void setListItems() {
    listItems.add(ModuleInfo(
        name: 'store_Settings'.tr,
        value: (settingDetails.value.stores ?? 0).toString(),
        action: AppConstants.action.store));
    listItems.add(ModuleInfo(
        name: 'suppliers'.tr,
        value: (settingDetails.value.suppliers ?? 0).toString(),
        action: AppConstants.action.suppliers));
    listItems.add(ModuleInfo(
        name: 'catalogue'.tr,
        value: (settingDetails.value.categories ?? 0).toString(),
        action: AppConstants.action.categories));
    listItems.add(ModuleInfo(
        name: 'project'.tr,
        value: (settingDetails.value.projects ?? 0).toString(),
        action: AppConstants.action.projects));
    listItems.add(ModuleInfo(
        name: 'draft_orders'.tr,
        value: "",
        action: AppConstants.action.draftOrders));
  }

  // void getProjectDetailsApi() {
  //   isLoading.value = true;
  //   Map<String, dynamic> map = {};
  //   map["company_id"] = ApiConstants.companyId;
  //   map["project_id"] = projectId;
  //
  //   _api.getProjectDetails(
  //     queryParameters: map,
  //     onSuccess: (ResponseModel responseModel) {
  //       if (responseModel.isSuccess) {
  //         isMainViewVisible.value = true;
  //         ProjectDetailsApiResponse response =
  //             ProjectDetailsApiResponse.fromJson(
  //                 jsonDecode(responseModel.result!));
  //         projectInfo = response.info;
  //         if (projectInfo != null) {
  //           updateItemsWithApi(projectInfo!);
  //         }
  //       } else {
  //         AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
  //       }
  //       isLoading.value = false;
  //     },
  //     onError: (ResponseModel error) {
  //       isLoading.value = false;
  //       if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
  //         isInternetNotAvailable.value = true;
  //         // AppUtils.showSnackBarMessage('no_internet'.tr);
  //         // Utils.showSnackBarMessage('no_internet'.tr);
  //       } else if (error.statusMessage!.isNotEmpty) {
  //         AppUtils.showSnackBarMessage(error.statusMessage ?? "");
  //       }
  //     },
  //   );
  // }

  void onItemClick(String action) {
    print("action:" + action);
    if (action == AppConstants.action.projects) {
      moveToScreen(rout: AppRoutes.buyerProjectsScreen);
    } else if (action == AppConstants.action.store) {
      moveToScreen(rout: AppRoutes.buyerStoresScreen);
    } else if (action == AppConstants.action.suppliers) {
      moveToScreen(rout: AppRoutes.buyerSupplierScreen);
    } else if (action == AppConstants.action.categories) {
      moveToScreen(rout: AppRoutes.buyerCatalogueScreen);
    } else if (action == AppConstants.action.draftOrders) {
      moveToScreen(rout: AppRoutes.buyerDraftOrdersScreen);
    }
  }

  Future<void> moveToScreen({required String rout, dynamic arguments}) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated.value = true;
    }
  }

  void onBackPress() {
    Get.back(result: isDataUpdated.value);
  }
}
