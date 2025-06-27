import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/listener/DialogButtonClickListener.dart';
import 'package:otm_inventory/pages/common/listener/menu_item_listener.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/teams/team_details/controller/team_details_repository.dart';
import 'package:otm_inventory/pages/teams/team_details/model/team_details_response.dart';
import 'package:otm_inventory/pages/teams/team_list/controller/team_list_repository.dart';
import 'package:otm_inventory/pages/teams/team_list/model/team_info.dart';
import 'package:otm_inventory/pages/teams/team_list/model/team_list_response.dart';
import 'package:otm_inventory/pages/permissions/user_list/controller/user_list_repository.dart';
import 'package:otm_inventory/pages/permissions/user_list/model/user_list_response.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/AlertDialogHelper.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class TeamDetailsController extends GetxController
    implements MenuItemListener, DialogButtonClickListener {
  final _api = TeamDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isClearVisible = false.obs,
      isDataUpdated = false.obs;
  final teamInfo = TeamInfo().obs;
  int teamId = 0;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      teamId = arguments[AppConstants.intentKey.teamId] ?? 0;
    }
    getTeamDetailsApi();
  }

  void getTeamDetailsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["team_id"] = teamId;
    _api.getTeamDetails(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          TeamDetailsResponse response =
              TeamDetailsResponse.fromJson(jsonDecode(responseModel.result!));
          teamInfo.value = response.info!;
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showApiResponseMessage('no_internet'.tr);
          // Utils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void archiveTeamApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    // map["company_id"] = ApiConstants.companyId;
    map["team_id"] = teamId;
    _api.archiveTeam(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showApiResponseMessage('no_internet'.tr);
          // Utils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void deleteTeamApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["team_id"] = teamId;
    _api.deleteTeam(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          Get.back(result: true);
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showApiResponseMessage('no_internet'.tr);
          // Utils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  showDeleteTeamDialog() async {
    AlertDialogHelper.showAlertDialog(
        "",
        'are_you_sure_you_want_to_delete'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        this,
        AppConstants.dialogIdentifier.deleteTeam);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.deleteTeam) {
      deleteTeamApi();
      Get.back();
    }
  }

  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    // listItems.add(ModuleInfo(
    //     name: 'create_new_team'.tr, action: AppConstants.action.add));
    if (teamInfo.value.isSubcontractor ?? false) {
      listItems.add(ModuleInfo(
          name: 'sub_contractor_details'.tr,
          action: AppConstants.action.subContractorDetails));
    } else {
      listItems
          .add(ModuleInfo(name: 'edit'.tr, action: AppConstants.action.edit));
      listItems.add(
          ModuleInfo(name: 'delete'.tr, action: AppConstants.action.delete));
      listItems.add(ModuleInfo(
          name: 'create_code'.tr, action: AppConstants.action.createCode));
      listItems.add(ModuleInfo(
          name: 'join_a_company'.tr, action: AppConstants.action.joinCompany));
      listItems.add(ModuleInfo(
          name: 'archive'.tr, action: AppConstants.action.archiveTeam));
    }

    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  @override
  Future<void> onSelectMenuItem(ModuleInfo info, String dialogType) async {
    if (info.action == AppConstants.action.edit) {
      var arguments = {
        AppConstants.intentKey.teamInfo: teamInfo.value,
      };
      moveToScreen(AppRoutes.createTeamScreen, arguments);
    } else if (info.action == AppConstants.action.delete) {
      showDeleteTeamDialog();
    } else if (info.action == AppConstants.action.createCode) {
      var arguments = {
        AppConstants.intentKey.teamId: teamId,
      };
      moveToScreen(AppRoutes.teamGenerateOtpScreen, arguments);
    } else if (info.action == AppConstants.action.subContractorDetails) {
      var arguments = {
        AppConstants.intentKey.teamId: teamId,
        AppConstants.intentKey.companyId:
            teamInfo.value.subcontractorCompanyId ?? 0,
      };
      Get.toNamed(AppRoutes.subContractorDetailsScreen, arguments: arguments);
    } else if (info.action == AppConstants.action.joinCompany) {
      var arguments = {
        AppConstants.intentKey.teamId: teamId,
      };
      moveToScreen(AppRoutes.joinTeamToCompanyScreen, arguments);
    } else if (info.action == AppConstants.action.archiveTeam) {
      archiveTeamApi();
    }
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated.value = true;
      getTeamDetailsApi();
    }
  }

  void onBackPress() {
    Get.back(result: isDataUpdated.value);
  }
}
