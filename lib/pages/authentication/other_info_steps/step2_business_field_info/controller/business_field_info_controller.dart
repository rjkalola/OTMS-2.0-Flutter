import 'dart:convert';

import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step1_team_users_count_info/controller/team_users_count_info_repository.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step1_team_users_count_info/model/CompanyResourcesResponse.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step2_business_field_info/controller/business_field_info_repository.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

import '../../../../../utils/app_constants.dart';

class BusinessFieldInfoController extends GetxController {
  final _api = BusinessFieldInfoRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final listItems = <ModuleInfo>[].obs;
  final selectedIndex = 0.obs;
  int teamId = 0;

  @override
  void onInit() {
    super.onInit();
    // listItems.value = getItemsList();
    var arguments = Get.arguments;
    if (arguments != null) {
      teamId = arguments[AppConstants.intentKey.permissionStep1Info];
    }
    getCompanyResourcesApi();
  }

  onClickContinueButton() {
    var arguments = {
      AppConstants.intentKey.permissionStep1Info: teamId,
      AppConstants.intentKey.permissionStep2Info:
          listItems[selectedIndex.value].id,
    };
    Get.toNamed(AppRoutes.selectToolScreen, arguments: arguments);
  }

  List<ModuleInfo> getItemsList() {
    var list = <ModuleInfo>[];
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = "Construction";
    list.add(info);

    info = ModuleInfo();
    info.name = "Heathcare & Wellness";
    list.add(info);

    info = ModuleInfo();
    info.name = "Food Services";
    list.add(info);

    info = ModuleInfo();
    info.name = "Shops & Retail";
    list.add(info);

    info = ModuleInfo();
    info.name = "Cleaning & Sanitation";
    list.add(info);

    info = ModuleInfo();
    info.name = "Production & Logistics";
    list.add(info);

    info = ModuleInfo();
    info.name = "Security & Patrol";
    list.add(info);

    return list;
  }

  void getCompanyResourcesApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["flag"] = "industryList";
    TeamUsersCountInfoRepository().getCompanyResourcesApi(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          CompanyResourcesResponse response = CompanyResourcesResponse.fromJson(
              jsonDecode(responseModel.result!));
          listItems.value = response.info ?? [];
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

// bool valid(bool isAutoLogin) {
//   if (!isAutoLogin) {
//     return formKey.currentState!.validate();
//   } else {
//     return true;
//   }
// }
}
