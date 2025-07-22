import 'dart:convert';

import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step1_team_users_count_info/controller/team_users_count_info_repository.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step1_team_users_count_info/model/CompanyResourcesResponse.dart';
import 'package:otm_inventory/pages/company/company_details/controller/company_details_repository.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';
import 'package:otm_inventory/utils/app_constants.dart';

class TeamUsersCountInfoController extends GetxController {
  final _api = TeamUsersCountInfoRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final listItems = <ModuleInfo>[].obs;
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // isMainViewVisible.value = true;
    // listItems.value = getItemsList();
    getCompanyResourcesApi();
  }

  onClickContinueButton() {
    var arguments = {
      AppConstants.intentKey.permissionStep1Info:
          listItems[selectedIndex.value].id,
    };
    Get.toNamed(AppRoutes.businessFieldInfoScreen, arguments: arguments);
  }

  List<ModuleInfo> getItemsList() {
    var list = <ModuleInfo>[];
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = "1-10";
    list.add(info);

    info = ModuleInfo();
    info.name = "11-30";
    list.add(info);

    info = ModuleInfo();
    info.name = "31-50";
    list.add(info);

    info = ModuleInfo();
    info.name = "51-100";
    list.add(info);

    info = ModuleInfo();
    info.name = "101-200";
    list.add(info);

    info = ModuleInfo();
    info.name = "200+";
    list.add(info);

    info = ModuleInfo();
    info.name = "1-10";
    list.add(info);

    info = ModuleInfo();
    info.name = "11-30";
    list.add(info);

    info = ModuleInfo();
    info.name = "31-50";
    list.add(info);

    info = ModuleInfo();
    info.name = "51-100";
    list.add(info);

    info = ModuleInfo();
    info.name = "101-200";
    list.add(info);

    info = ModuleInfo();
    info.name = "200+";
    list.add(info);

    info = ModuleInfo();
    info.name = "1-10";
    list.add(info);

    info = ModuleInfo();
    info.name = "11-30";
    list.add(info);

    info = ModuleInfo();
    info.name = "31-50";
    list.add(info);

    info = ModuleInfo();
    info.name = "51-100";
    list.add(info);

    info = ModuleInfo();
    info.name = "101-200";
    list.add(info);

    info = ModuleInfo();
    info.name = "200+";
    list.add(info);

    info = ModuleInfo();
    info.name = "1-10";
    list.add(info);

    info = ModuleInfo();
    info.name = "11-30";
    list.add(info);

    info = ModuleInfo();
    info.name = "31-50";
    list.add(info);

    info = ModuleInfo();
    info.name = "51-100";
    list.add(info);

    info = ModuleInfo();
    info.name = "101-200";
    list.add(info);

    info = ModuleInfo();
    info.name = "200+";
    list.add(info);

    info = ModuleInfo();
    info.name = "1-10";
    list.add(info);

    info = ModuleInfo();
    info.name = "11-30";
    list.add(info);

    info = ModuleInfo();
    info.name = "31-50";
    list.add(info);

    info = ModuleInfo();
    info.name = "51-100";
    list.add(info);

    info = ModuleInfo();
    info.name = "101-200";
    list.add(info);

    info = ModuleInfo();
    info.name = "200+";
    list.add(info);

    return list;
  }

  void getCompanyResourcesApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["flag"] = "numberOfEmployeeList";
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

// bool valid(bool isAutoLogin) {
//   if (!isAutoLogin) {
//     return formKey.currentState!.validate();
//   } else {
//     return true;
//   }
// }
}
