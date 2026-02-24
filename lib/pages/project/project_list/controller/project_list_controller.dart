import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/project/address_list/controller/address_list_repository.dart';
import 'package:belcka/pages/project/address_list/model/address_info.dart';
import 'package:belcka/pages/project/address_list/model/address_list_response.dart';
import 'package:belcka/pages/project/project_details/controller/project_details_repository.dart';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/pages/project/project_info/model/project_list_response.dart';
import 'package:belcka/pages/project/project_list/controller/project_list_repository.dart';
import 'package:belcka/pages/project/project_list/view/active_project_dialog.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectListController extends GetxController
    implements MenuItemListener, SelectItemListener, DialogButtonClickListener {
  final _api = ProjectListRepository();
  final searchAddressController = TextEditingController().obs;
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isClearVisible = false.obs,
      isDataUpdated = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;
  RxString selectedStatusFilter = "all".obs, activeProjectTitle = "".obs;
  RxInt activeProjectId = 0.obs,
      allCount = 0.obs,
      newCount = 0.obs,
      pendingCount = 0.obs,
      completeCount = 0.obs;

  final projectsList = <ProjectInfo>[].obs;
  final addressList = <AddressInfo>[].obs;
  final tempList = <AddressInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    getProjectListApi();
  }

  void getProjectListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;

    _api.getProjectList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          clearAddress();
          ProjectListResponse response =
              ProjectListResponse.fromJson(jsonDecode(responseModel.result!));
          // tempList.clear();
          // tempList.addAll(response.info ?? []);
          projectsList.clear();
          projectsList.addAll(response.info!);
          activeProjectId.value = response.id ?? 0;
          activeProjectTitle.value = response.name ?? "";
          // projectsList.refresh();
          if (activeProjectId.value != 0) {
            getAddressListApi(0);
          } else {
            isMainViewVisible.value = true;
            tempList.clear();
            addressList.clear();
            addressList.refresh();
          }
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

  void getAddressListApi(int status) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["project_id"] = activeProjectId.value;
    map["status"] = status;
    // map["project_id"] = 30;

    AddressListRepository().getAddressList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          AddressListResponse response =
              AddressListResponse.fromJson(jsonDecode(responseModel.result!));
          allCount.value = response.all ?? 0;
          newCount.value = response.latest ?? 0;
          pendingCount.value = response.pending ?? 0;
          completeCount.value = response.completed ?? 0;
          tempList.clear();
          tempList.addAll(response.info ?? []);
          addressList.value = tempList;
          addressList.refresh();
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void activeProjectAPI(int id, String title,int companyId) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = companyId;
    map["id"] = id;

    _api.activeProject(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
          activeProjectId.value = id;
          activeProjectTitle.value = title;
          getAddressListApi(0);
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

  void archiveProjectApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = activeProjectId.value;
    ProjectDetailsRepository().archiveProject(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          getProjectListApi();
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

  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    listItems.add(
        ModuleInfo(name: 'add_project'.tr, action: AppConstants.action.add));
    if (activeProjectId.value != 0) {
      listItems.add(ModuleInfo(
          name: 'edit_project'.tr, action: AppConstants.action.edit));
      listItems.add(ModuleInfo(
          name: 'archive_project'.tr, action: AppConstants.action.delete));
      listItems.add(ModuleInfo(
          name: 'add_address'.tr, action: AppConstants.action.addAddress));
      listItems.add(ModuleInfo(
          name: 'archived_address'.tr,
          action: AppConstants.action.archivedAddress));
    }
    listItems.add(ModuleInfo(
        name: 'archived_projects'.tr,
        action: AppConstants.action.archivedProjects));

    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  @override
  Future<void> onSelectMenuItem(ModuleInfo info, String dialogType) async {
    if (info.action == AppConstants.action.add) {
      moveToScreen(AppRoutes.addProjectScreen, null);
    } else if (info.action == AppConstants.action.edit) {
      if (activeProjectId.value != 0) {
        ProjectInfo? projectInfo;
        for (var info in projectsList) {
          if (activeProjectId.value == (info.id ?? 0)) {
            projectInfo = info;
            break;
          }
        }
        if (projectInfo != null) {
          var arguments = {
            AppConstants.intentKey.projectInfo: projectInfo,
          };
          moveToScreen(AppRoutes.addProjectScreen, arguments);
        }
      }
    } else if (info.action == AppConstants.action.delete) {
      showDeleteProjectDialog();
    } else if (info.action == AppConstants.action.archivedProjects) {
      moveToScreen(AppRoutes.archiveProjectListScreen, null);
    } else if (info.action == AppConstants.action.addAddress) {
      if (activeProjectId.value != 0) {
        ProjectInfo? projectInfo;
        for (var info in projectsList) {
          if (activeProjectId.value == (info.id ?? 0)) {
            projectInfo = info;
            break;
          }
        }
        if (projectInfo != null) {
          var arguments = {
            AppConstants.intentKey.projectInfo: projectInfo,
          };
          moveToScreen(AppRoutes.addAddressScreen, arguments);
        }
      }
    } else if (info.action == AppConstants.action.archivedAddress) {
      var arguments = {
        AppConstants.intentKey.projectId: activeProjectId.value,
      };
      moveToScreen(AppRoutes.archiveAddressListScreen, arguments);
    }
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated.value = true;
      getProjectListApi();
    }
  }

  void showActiveProjectDialogDialog() {
    if (projectsList.isNotEmpty) {
      Get.bottomSheet(
          ActiveProjectDialog(
            dialogType: AppConstants.dialogIdentifier.selectProject,
            list: projectsList,
            selectedProjectId: activeProjectId.value,
            listener: this,
          ),
          backgroundColor: Colors.transparent,
          isScrollControlled: true);
    } else {
      AppUtils.showToastMessage('empty_project_list'.tr);
    }
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectProject) {
      activeProjectAPI(id, name,projectsList[position].companyId??0);
    }
  }

  showDeleteProjectDialog() async {
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
      archiveProjectApi();
      Get.back();
    }
  }

  Future<void> searchAddress(String value) async {
    print(value);
    List<AddressInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) => (!StringHelper.isEmptyString(element.name) &&
              element.name!.toLowerCase().contains(value.toLowerCase())))
          .toList();
    }
    addressList.value = results;
  }

  void clearAddress() {
    searchAddressController.value.clear();
    searchAddress("");
  }
}
