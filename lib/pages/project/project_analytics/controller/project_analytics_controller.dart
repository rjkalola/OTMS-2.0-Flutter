import 'dart:async';
import 'dart:convert';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/project/project_analytics/model/project_analytics_model.dart';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/pages/project/project_info/model/project_list_response.dart';
import 'package:belcka/pages/project/project_list/controller/project_list_repository.dart';
import 'package:belcka/pages/project/project_list/view/active_project_dialog.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectAnalyticsController extends GetxController
    implements MenuItemListener, SelectItemListener, DialogButtonClickListener {
  final _api = ProjectListRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isDataUpdated = false.obs;
  RxString activeProjectTitle = "".obs;
  RxInt activeProjectId = 0.obs;
  final projectsList = <ProjectInfo>[].obs;
  final selectedPaymentTab = 0.obs;

  static DateTime _d(int y, int m, int d) => DateTime(y, m, d);

  final List<BudgetItem> budgets = const [
    BudgetItem(label: 'Labor', amount: 150000, spent: 110000, color: Color(0xFF22C55E)),
    BudgetItem(
        label: 'Materials',
        amount: 200000,
        spent: 220500.42,
        color: Color(0xFFF97316),
        overspent: true,
        overspentBy: 20500.42),
    BudgetItem(label: 'Others', amount: 60000, spent: 30000, color: Color(0xFF60A5FA)),
  ];

  final List<Payment> received = [
    Payment(address: '1 Topham, Woodgreen', postcode: 'IG2 9PS', amount: 25000, date: _d(2025, 9, 16)),
    Payment(address: '24 Topham, Woodgreen', postcode: 'IP2 1PS', amount: 25000, date: _d(2025, 9, 16)),
    Payment(address: '168 Topham, Woodgreen', postcode: 'EG2 1PS', amount: 50000, date: _d(2025, 7, 12)),
    Payment(address: '3 Topham, Woodgreen', postcode: 'IG2 1PS', amount: 50000, date: _d(2025, 6, 13)),
  ];

  @override
  void onInit() {
    super.onInit();
    getProjectAnalyticsApi();
  }

  void getProjectListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.getProjectList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          ProjectListResponse response =
          ProjectListResponse.fromJson(jsonDecode(responseModel.result!));
          projectsList.clear();
          projectsList.addAll(response.info!);
          activeProjectId.value = response.id ?? 0;
          activeProjectTitle.value = response.name ?? "";
          isMainViewVisible.value = true;
        }
        else{
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

  void getProjectAnalyticsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.getProjectList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          ProjectListResponse response =
          ProjectListResponse.fromJson(jsonDecode(responseModel.result!));
          projectsList.clear();
          projectsList.addAll(response.info!);
          activeProjectId.value = response.id ?? 0;
          activeProjectTitle.value = response.name ?? "";
          isMainViewVisible.value = true;
        }
        else{
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

  void activeProjectAPI(int id, String title, int companyId) {
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
        }
        else{
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
      getProjectAnalyticsApi();
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
      activeProjectAPI(id, name, projectsList[position].companyId ?? 0);
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

  void onItemTapped(int index) {

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
      Get.back();
    }
  }
}
