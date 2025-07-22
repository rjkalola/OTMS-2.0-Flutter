import 'dart:convert';

import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step1_team_users_count_info/model/CompanyResourcesResponse.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step3_select_tools/controller/select_tools_repository.dart';
import 'package:otm_inventory/pages/company/company_details/controller/company_details_repository.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

import '../../../../../utils/app_constants.dart';

class SelectToolsController extends GetxController {
  final _api = SelectToolsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final listItems = <ModuleInfo>[].obs;
  final selectedIndex = 0.obs;
  int teamId = 0, businessId = 0;

  @override
  void onInit() {
    super.onInit();
    // listItems.value = getItemsList();
    var arguments = Get.arguments;
    if (arguments != null) {
      teamId = arguments[AppConstants.intentKey.permissionStep1Info];
      businessId = arguments[AppConstants.intentKey.permissionStep2Info];
      print("teamId:" + teamId.toString());
      print("businessId:" + businessId.toString());
    }
    getCompanyResourcesApi();
  }

  List<ModuleInfo> getItemsList() {
    var list = <ModuleInfo>[];
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = "Time Clock";
    list.add(info);

    info = ModuleInfo();
    info.name = "TimeSheets";
    list.add(info);

    info = ModuleInfo();
    info.name = "Tasks";
    list.add(info);

    info = ModuleInfo();
    info.name = "Projects";
    list.add(info);

    return list;
  }

  void getCompanyResourcesApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["flag"] = "industryList";
    CompanyDetailsRepository().getCompanyResourcesApi(
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

  void storeCompanyDataUrlAPI(String permissionIds) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["team_size_id"] = teamId;
    map["business_id"] = businessId;
    map["permission_id"] = permissionIds;
    _api.storeCompanyDataUrlAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showSnackBarMessage(response.Message ?? "");
          Get.offAllNamed(AppRoutes.dashboardScreen);
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        }
        // else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        // }
      },
    );
  }

  onClickContinueButton() {
    print("teamId:" + teamId.toString());
    print("businessId:" + businessId.toString());
    List<int> list = [];
    for (ModuleInfo info in listItems) {
      if (info.check ?? false) {
        list.add(info.id ?? 0);
      }
    }
    storeCompanyDataUrlAPI(list.toString());
    print("permissionId:" + list.toString());
  }

// bool valid(bool isAutoLogin) {
//   if (!isAutoLogin) {
//     return formKey.currentState!.validate();
//   } else {
//     return true;
//   }
// }
}
