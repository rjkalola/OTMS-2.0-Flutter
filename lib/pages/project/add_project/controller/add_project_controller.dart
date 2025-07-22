import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step1_team_users_count_info/model/CompanyResourcesResponse.dart';
import 'package:otm_inventory/pages/common/drop_down_list_dialog.dart';
import 'package:otm_inventory/pages/common/drop_down_multi_selection_list_dialog.dart';
import 'package:otm_inventory/pages/common/listener/company_resources_listener.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/listener/select_multi_item_listener.dart';
import 'package:otm_inventory/pages/project/add_project/controller/add_project_repository.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/company_resources.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class AddProjectController extends GetxController
    implements
        CompanyResourcesListener,
        SelectItemListener,
        SelectMultiItemListener {
  final projectNameController = TextEditingController().obs;
  final shiftController = TextEditingController().obs;
  final teamController = TextEditingController().obs;
  final siteAddressController = TextEditingController().obs;
  final budgetController = TextEditingController().obs;
  final addGeofenceController = TextEditingController().obs;
  final addAddressesController = TextEditingController().obs;
  final projectCodeController = TextEditingController().obs;
  final statusController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;
  final formKey = GlobalKey<FormState>();
  final _api = AddProjectRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSaveEnable = false.obs;
  final title = ''.obs;
  int shiftId = 0;
  String teamIds = "";
  final shiftsList = <ModuleInfo>[].obs;
  final teamsList = <ModuleInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      // teamInfo = arguments[AppConstants.intentKey.teamInfo];
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
    title.value = 'add_project'.tr;
    /*if (teamInfo != null) {
      title.value = 'Edit Team'.tr;
      teamNameController.value.text = teamInfo?.name ?? "";
      supervisorController.value.text = teamInfo?.supervisorName ?? "";
      supervisorId = teamInfo?.supervisorId ?? 0;
      teamMembersList.addAll(teamInfo?.teamMembers ?? []);
    } else {
      title.value = 'create_new_team'.tr;
      isSaveEnable.value = true;
    }*/
  }

/*  void getUserListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    UserListRepository().getUserList(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          UserListResponse response =
              UserListResponse.fromJson(jsonDecode(responseModel.result!));
          userList.value = response.info!;
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

  void createTeamApi() async {
    if (valid()) {
      Map<String, dynamic> map = {};
      map["company_id"] = ApiConstants.companyId;
      map["supervisor_id"] = supervisorId;
      map["name"] = StringHelper.getText(teamNameController.value);
      map["team_member_ids"] =
          UserUtils.getCommaSeparatedIdsString(teamMembersList);
      isLoading.value = true;
      _api.addTeam(
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
  }*/

  bool valid() {
    return formKey.currentState!.validate();
  }

  @override
  void onCompanyResourcesResponse(bool isSuccess,
      CompanyResourcesResponse? response, String flag, bool isInternet) {
    if (isInternet) {
      if (isSuccess && response != null) {
        if (flag == AppConstants.companyResourcesFlag.shiftList) {
          shiftsList.addAll(response.info ?? []);
          CompanyResources.getResourcesApi(
              flag: AppConstants.companyResourcesFlag.teamList, listener: this);
        } else if (flag == AppConstants.companyResourcesFlag.teamList) {
          isLoading.value = false;
          isMainViewVisible.value = true;
          teamsList.addAll(response.info ?? []);
        }
      }
    } else {
      isInternetNotAvailable.value = true;
      // AppUtils.showApiResponseMessage('no_internet'.tr);
    }
  }

  void showShiftList() {
    if (shiftsList.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.selectShift,
          'select_shift'.tr, shiftsList, this);
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

  void showDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        DropDownListDialog(
          title: title,
          dialogType: dialogType,
          list: list,
          listener: listener,
          isCloseEnable: true,
          isSearchEnable: true,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
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
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectShift) {
      shiftController.value.text = name;
      shiftId = id;
    } else if (action == AppConstants.dialogIdentifier.selectTeam) {
      teamController.value.text = name;
    }
  }

  @override
  void onSelectMultiItem(List<ModuleInfo> tempList, String action) {
    if (action == AppConstants.dialogIdentifier.selectTeam) {
      List<ModuleInfo> listSelectedItems = [];
      for (int i = 0; i < tempList.length; i++) {
        if (tempList[i].check ?? false) {
          listSelectedItems.add(tempList[i]);
        }
      }
      teamController.value.text =
          StringHelper.getCommaSeparatedNames(listSelectedItems);
      teamIds = StringHelper.getCommaSeparatedIds(listSelectedItems);
    }
  }
}
