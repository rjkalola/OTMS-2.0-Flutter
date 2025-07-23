import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step1_team_users_count_info/model/CompanyResourcesResponse.dart';
import 'package:otm_inventory/pages/common/drop_down_multi_selection_list_dialog.dart';
import 'package:otm_inventory/pages/common/listener/DialogButtonClickListener.dart';
import 'package:otm_inventory/pages/common/listener/company_resources_listener.dart';
import 'package:otm_inventory/pages/common/listener/menu_item_listener.dart';
import 'package:otm_inventory/pages/common/listener/select_multi_item_listener.dart';
import 'package:otm_inventory/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:otm_inventory/pages/project/add_project/controller/add_project_repository.dart';
import 'package:otm_inventory/pages/project/project_info/model/project_info.dart';
import 'package:otm_inventory/utils/AlertDialogHelper.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/company_resources.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class AddProjectController extends GetxController
    implements
        CompanyResourcesListener,
        SelectMultiItemListener,
        MenuItemListener,
        DialogButtonClickListener {
  final projectNameController = TextEditingController().obs;
  final shiftController = TextEditingController().obs;
  final teamController = TextEditingController().obs;
  final siteAddressController = TextEditingController().obs;
  final budgetController = TextEditingController().obs;
  final projectCodeController = TextEditingController().obs;

  // final addGeofenceController = TextEditingController().obs;
  // final addAddressesController = TextEditingController().obs;

  // final statusController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;
  final formKey = GlobalKey<FormState>();
  final _api = AddProjectRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSaveEnable = false.obs;
  final title = ''.obs;
  String teamIds = "",
      shiftIds = "";
  final shiftsList = <ModuleInfo>[].obs;
  final teamsList = <ModuleInfo>[].obs;
  ProjectInfo? projectInfo;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      projectInfo = arguments[AppConstants.intentKey.projectInfo];
    }
    setInitData();
    loadResources(true);
  }

  void loadResources(bool isProgress) {
    isLoading.value = isProgress;
    CompanyResources.getResourcesApi(
        flag: AppConstants.companyResourcesFlag.shiftList, listener: this);
  }

  void setInitData() {
    if (projectInfo != null) {
      title.value = 'update_project'.tr;
      projectNameController.value.text = projectInfo?.name ?? "";
      siteAddressController.value.text = projectInfo?.address ?? "";
      budgetController.value.text = projectInfo?.budget ?? "";
      descriptionController.value.text = projectInfo?.description ?? "";
      projectCodeController.value.text = projectInfo?.code ?? "";
      if (projectInfo!.shifts!.isNotEmpty) {
        shiftController.value.text =
            StringHelper.getCommaSeparatedNames(projectInfo!.shifts!);
        shiftIds = StringHelper.getCommaSeparatedIds(projectInfo!.shifts!);
      }
      if (projectInfo!.teams!.isNotEmpty) {
        teamController.value.text =
            StringHelper.getCommaSeparatedNames(projectInfo!.teams!);
        teamIds = StringHelper.getCommaSeparatedIds(projectInfo!.teams!);
      }
    } else {
      title.value = 'add_project'.tr;
      isSaveEnable.value = true;
    }
  }

  void addProjectApi() async {
    if (valid()) {
      Map<String, dynamic> map = {};
      map["company_id"] = ApiConstants.companyId;
      map["name"] = StringHelper.getText(projectNameController.value);
      map["address"] = StringHelper.getText(siteAddressController.value);
      map["budget"] = StringHelper.getText(budgetController.value);
          map["code"] = StringHelper.getText(projectCodeController.value);
      map["description"] = StringHelper.getText(descriptionController.value);
      map["team_ids"] = teamIds;
      map["shift_ids"] = shiftIds;

      isLoading.value = true;
      _api.addProject(
        data: map,
        onSuccess: (ResponseModel responseModel) {
          if (responseModel.isSuccess) {
            BaseResponse response =
            BaseResponse.fromJson(jsonDecode(responseModel.result!));
            AppUtils.showApiResponseMessage(response.Message ?? "");
            Get.back(result: true);
          } else {
            AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
          }
          isLoading.value = false;
        },
        onError: (ResponseModel error) {
          isLoading.value = false;
          if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
            AppUtils.showApiResponseMessage('no_internet'.tr);
          } else if (error.statusMessage!.isNotEmpty) {
            AppUtils.showApiResponseMessage(error.statusMessage);
          }
        },
      );
    }
  }

  void updateProjectApi() async {
    if (valid()) {
      Map<String, dynamic> map = {};
      map["id"] = projectInfo?.id ?? 0;
      map["company_id"] = ApiConstants.companyId;
      map["name"] = StringHelper.getText(projectNameController.value);
      map["address"] = StringHelper.getText(siteAddressController.value);
      map["budget"] = StringHelper.getText(budgetController.value);
      map["code"] = StringHelper.getText(projectCodeController.value);
      map["description"] = StringHelper.getText(descriptionController.value);
      map["team_ids"] = teamIds;
      map["shift_ids"] = shiftIds;

      isLoading.value = true;
      _api.updateProject(
        data: map,
        onSuccess: (ResponseModel responseModel) {
          if (responseModel.isSuccess) {
            BaseResponse response =
            BaseResponse.fromJson(jsonDecode(responseModel.result!));
            AppUtils.showApiResponseMessage(response.Message ?? "");
            Get.back(result: true);
          } else {
            AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
          }
          isLoading.value = false;
        },
        onError: (ResponseModel error) {
          isLoading.value = false;
          if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
            AppUtils.showApiResponseMessage('no_internet'.tr);
          } else if (error.statusMessage!.isNotEmpty) {
            AppUtils.showApiResponseMessage(error.statusMessage);
          }
        },
      );
    }
  }

  void archiveProjectApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    // map["company_id"] = ApiConstants.companyId;
    map["id"] = projectInfo?.id ?? 0;
    _api.archiveProject(
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

  void deleteProjectApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = projectInfo?.id ?? 0;
    _api.deleteProject(
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

  bool valid() {
    return formKey.currentState!.validate();
  }

  @override
  void onCompanyResourcesResponse(bool isSuccess,
      CompanyResourcesResponse? response, String flag, bool isInternet) {
    if (isInternet) {
      if (isSuccess && response != null) {
        if (flag == AppConstants.companyResourcesFlag.shiftList) {
          if (projectInfo != null) {
            shiftsList.addAll(StringHelper.getCheckedItemsList(
                response.info ?? [], projectInfo!.shifts ?? []));
          } else {
            shiftsList.addAll(response.info ?? []);
          }
          CompanyResources.getResourcesApi(
              flag: AppConstants.companyResourcesFlag.teamList, listener: this);
        } else if (flag == AppConstants.companyResourcesFlag.teamList) {
          isLoading.value = false;
          isMainViewVisible.value = true;
          if (projectInfo != null) {
            teamsList.addAll(StringHelper.getCheckedItemsList(
                response.info ?? [], projectInfo!.teams ?? []));
          } else {
            teamsList.addAll(response.info ?? []);
          }
        }
      }
    } else {
      isInternetNotAvailable.value = true;
      // AppUtils.showApiResponseMessage('no_internet'.tr);
    }
  }

  void showShiftList() {
    if (shiftsList.isNotEmpty) {
      showMultiSelectionDropDownDialog(
          AppConstants.dialogIdentifier.selectShift,
          'select_shift'.tr,
          shiftsList,
          this);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showTeamList() {
    if (teamsList.isNotEmpty) {
      showMultiSelectionDropDownDialog(AppConstants.dialogIdentifier.selectTeam,
          'select_teams'.tr, teamsList, this);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showMultiSelectionDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectMultiItemListener listener) {
    Get.bottomSheet(
        DropDownMultiSelectionListDialog(
          title: title,
          dialogType: dialogType,
          list: list,
          listener: listener,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectMultiItem(List<ModuleInfo> tempList, String action) {
    isSaveEnable.value = true;
    List<ModuleInfo> listSelectedItems = [];
    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].check ?? false) {
        listSelectedItems.add(tempList[i]);
      }
    }
    if (action == AppConstants.dialogIdentifier.selectTeam) {
      teamController.value.text =
          StringHelper.getCommaSeparatedNames(listSelectedItems);
      teamIds = StringHelper.getCommaSeparatedIds(listSelectedItems);
    } else if (action == AppConstants.dialogIdentifier.selectShift) {
      shiftController.value.text =
          StringHelper.getCommaSeparatedNames(listSelectedItems);
      shiftIds = StringHelper.getCommaSeparatedIds(listSelectedItems);
    }
  }

  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    listItems
        .add(ModuleInfo(name: 'delete'.tr, action: AppConstants.action.delete));
    listItems.add(ModuleInfo(
        name: 'archive'.tr, action: AppConstants.action.archiveTeam));
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  @override
  Future<void> onSelectMenuItem(ModuleInfo info, String dialogType) async {
    if (info.action == AppConstants.action.delete) {
      showDeleteTeamDialog();
    } else if (info.action == AppConstants.action.archiveTeam) {
      archiveProjectApi();
    }
  }

  showDeleteTeamDialog() async {
    AlertDialogHelper.showAlertDialog(
        "",
        'are_you_sure_you_want_to_delete'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
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
      deleteProjectApi();
      Get.back();
    }
  }
}
