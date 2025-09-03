import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/project/archive_projects/controller/archive_project_list_repository.dart';
import 'package:belcka/pages/teams/archive_team_list/controller/archive_team_list_repository.dart';
import 'package:belcka/pages/teams/team_details/controller/team_details_repository.dart';
import 'package:belcka/pages/teams/team_list/controller/team_list_repository.dart';
import 'package:belcka/pages/teams/team_list/model/team_info.dart';
import 'package:belcka/pages/teams/team_list/model/team_list_response.dart';
import 'package:belcka/pages/permissions/user_list/controller/user_list_repository.dart';
import 'package:belcka/pages/permissions/user_list/model/user_list_response.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';

class ArchiveProjectListController extends GetxController
    implements MenuItemListener, DialogButtonClickListener {
  final _api = ArchiveProjectListRepository();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isClearVisible = false.obs,
      isDataUpdated = false.obs;
  final searchController = TextEditingController().obs;

  final projectList = <TeamInfo>[].obs;
  int selectedIndex = 0, selectedProjectId = 0;
  List<TeamInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    getArchiveProjectListApi();
  }
  Future<void> getArchiveProjectListApi() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.archiveProjectList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          TeamListResponse response =
          TeamListResponse.fromJson(jsonDecode(responseModel.result!));
          tempList.clear();
          tempList.addAll(response.info ?? []);
          projectList.value = tempList;
          projectList.refresh();
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

  void unArchiveProjectApi(int projectId, int index) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    // map["company_id"] = ApiConstants.companyId;
    map["id"] = projectId;
    _api.unArchiveProject(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isDataUpdated.value = true;
          BaseResponse response =
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
          projectList.removeAt(index);
          projectList.refresh();
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

  void deleteProjectApi(int projectId, int index) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = projectId;
    _api.deleteProject(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isDataUpdated.value = true;
          BaseResponse response =
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
          projectList.removeAt(index);
          projectList.refresh();
        }
        else{
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

  Future<void> searchItem(String value) async {
    print(value);
    List<TeamInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) => (!StringHelper.isEmptyString(element.name) &&
          element.name!.toLowerCase().contains(value.toLowerCase())))
          .toList();
    }
    projectList.value = results;
  }

  showDeleteProjectDialog(int projectId, int index) async {
    selectedProjectId = projectId;
    selectedIndex = index;
    AlertDialogHelper.showAlertDialog(
        "",
        'are_you_sure_you_want_to_delete'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.deleteProject);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.deleteProject) {
      deleteProjectApi(selectedProjectId, selectedIndex);
      Get.back();
    }
  }

  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    listItems.add(ModuleInfo(name: 'add'.tr, action: AppConstants.action.add));
    listItems.add(ModuleInfo(
        name: 'generate_code'.tr, action: AppConstants.action.generateCode));
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  @override
  Future<void> onSelectMenuItem(ModuleInfo info,String dialogType) async {
    if (info.action == AppConstants.action.add) {
      moveToScreen(AppRoutes.createTeamScreen, null);
    } else if (info.action == AppConstants.action.generateCode) {
      moveToScreen(AppRoutes.generateCompanyCodeScreen, null);
    }
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated.value = true;
      getArchiveProjectListApi();
    }
  }

  void onBackPress() {
    Get.back(result: isDataUpdated.value);
  }
}
