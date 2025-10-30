import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/dashboard/tabs/more_tab/view/more_tab.dart';
import 'package:belcka/pages/profile/my_account/controller/my_account_repository.dart';
import 'package:belcka/pages/project/project_details/controller/project_details_repository.dart';
import 'package:belcka/pages/project/project_details/model/project_details_api_response.dart';
import 'package:belcka/pages/project/project_details/model/project_detals_item.dart';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/pages/project/project_info/model/project_list_response.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import '../../../dashboard/tabs/home_tab2/view/home_tab.dart';

class ProjectDetailsController extends GetxController
    implements MenuItemListener, DialogButtonClickListener {
  final _api = ProjectDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isDataUpdated = false.obs;
  final selectedIndex = 0.obs;
  late final PageController pageController;
  final tabs = <Widget>[
    // StockListScreen(),
    HomeTab(),
    // ProfileTab(),
    MoreTab(),
    MoreTab(),
    MoreTab(),
    MoreTab(),
  ];

  final List<ProjectDetalsItem> items = [
    ProjectDetalsItem(
        title: 'team'.tr,
        subtitle: '',
        iconPath: Drawable.teamPermissionIcon,
        iconColor: "#000000",
        flagName: "Team"),
    ProjectDetalsItem(
        title: 'addresses'.tr,
        subtitle: '',
        badge: 0,
        iconPath: Drawable.homeAddressIcon,
        iconColor: "#000000",
        flagName: "Addresses"),
    ProjectDetalsItem(
        title: 'budget'.tr,
        subtitle: '',
        iconPath: Drawable.poundIcon,
        iconColor: "#000000",
        flagName: "Budget"),
    ProjectDetalsItem(
        title: 'project_details'.tr,
        subtitle: '',
        iconPath: Drawable.projectsIcon,
        iconColor: "#000000",
        flagName: "Project Details"),
    ProjectDetalsItem(
        title: 'trades'.tr,
        subtitle: '',
        iconPath: Drawable.tradesPermissionIcon,
        iconColor: "#000000",
        flagName: "Trades"),
    ProjectDetalsItem(
        title: 'check_in_'.tr,
        subtitle: '',
        iconPath: Drawable.clockIcon,
        iconColor: "#000000",
        flagName: "Check-In"),
  ];

  ProjectInfo? projectInfo;
  int projectId = 0;
  bool fromNotification = false;

  //Home Tab
  final selectedActionButtonPagerPosition = 0.obs;
  final dashboardActionButtonsController = PageController(
    initialPage: 0,
  );

  @override
  void onInit() {
    super.onInit();
    // isMainViewVisible.value = true;
    pageController = PageController(initialPage: selectedIndex.value);
    var arguments = Get.arguments;
    if (arguments != null) {
      projectId = arguments[AppConstants.intentKey.projectId] ?? 0;
      fromNotification =
          arguments[AppConstants.intentKey.fromNotification] ?? false;
    }
    getProjectDetailsApi();
  }

  void getProjectDetailsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["project_id"] = projectId;

    _api.getProjectDetails(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          ProjectDetailsApiResponse response =
              ProjectDetailsApiResponse.fromJson(
                  jsonDecode(responseModel.result!));
          projectInfo = response.info;
          if (projectInfo != null) {
            updateItemsWithApi(projectInfo!);
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

  void archiveProjectApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = projectInfo?.id ?? 0;
    _api.archiveProject(
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
          isInternetNotAvailable.value = true;
          // AppUtils.showApiResponseMessage('no_internet'.tr);
          // Utils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void updateItemsWithApi(ProjectInfo project) {
    for (var item in items) {
      switch (item.flagName) {
        case 'Team':
          item.subtitle = project.teams!.isNotEmpty
              ? project.teams!.map((e) => e.name).join(', ')
              : '';
          break;
        case 'Addresses':
          item.subtitle = project.addresses.toString();
          item.badge = project.completeAddress ?? 0;
          break;
        case 'Budget':
          item.subtitle = project.budget != null
              ? '${project.currency ?? ""}${project.budget ?? 0.00}'
              : '£0.00';
          break;
        case 'Trades':
          item.subtitle = project.trades.toString();
          break;
        case 'Project Details':
          item.subtitle = '';
          break;
        case 'Check-In':
          item.subtitle = project.checkIns.toString();
          break;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int index) {
    selectedIndex.value = index;
    print("selectedIndex.value:${selectedIndex.value}");
  }

  void onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated.value = true;
      getProjectDetailsApi();
    }
  }

  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    // listItems.add(ModuleInfo(
    //     name: 'archive_project'.tr,
    //     action: AppConstants.action.archiveProject));
    listItems.add(
        ModuleInfo(name: 'archive'.tr, action: AppConstants.action.delete));
    listItems
        .add(ModuleInfo(name: 'edit'.tr, action: AppConstants.action.edit));
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  @override
  void onSelectMenuItem(ModuleInfo info, String dialogType) {
    // TODO: implement onSelectMenuItem
    // if (info.action == AppConstants.action.archiveProject) {
    //   archiveProjectApi();
    // } else
    if (info.action == AppConstants.action.delete) {
      showDeleteTeamDialog();
    } else if (info.action == AppConstants.action.edit) {
      print("Edit click");
      var arguments = {
        AppConstants.intentKey.projectInfo: projectInfo,
      };
      moveToScreen(AppRoutes.addProjectScreen, arguments);
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
      archiveProjectApi();
      Get.back();
    }
  }

  void onBackPress() {
    if (fromNotification) {
      Get.offAllNamed(AppRoutes.dashboardScreen);
    } else {
      Get.back();
    }
  }
}
