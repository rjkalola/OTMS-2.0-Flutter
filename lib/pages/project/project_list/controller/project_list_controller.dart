import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/project/address_list/controller/address_list_repository.dart';
import 'package:belcka/pages/project/address_list/model/address_info.dart';
import 'package:belcka/pages/project/address_list/model/address_list_response.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/company/company_list/model/company_list_response.dart';
import 'package:belcka/pages/company/company_signup/model/company_info.dart';
import 'package:belcka/pages/profile/company_billings/controller/company_billings_repository.dart';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/pages/project/project_info/model/project_list_response.dart';
import 'package:belcka/pages/project/project_list/controller/project_list_repository.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';

class ProjectListController extends GetxController implements MenuItemListener {
  final _api = ProjectListRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isClearVisible = false.obs,
      isDataUpdated = false.obs;
  RxString selectedStatusFilter = "all".obs, activeProjectTitle = "".obs;
  RxInt activeProjectId = 0.obs;

  final projectsList = <ProjectInfo>[].obs;
  final addressList = <AddressInfo>[].obs;
  List<AddressInfo> tempList = [];

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
          ProjectListResponse response =
              ProjectListResponse.fromJson(jsonDecode(responseModel.result!));
          // tempList.clear();
          // tempList.addAll(response.info ?? []);
          projectsList.value.addAll(response.info!);
          // projectsList.refresh();
          getAddressListApi();
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

  void getAddressListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    // map["project_id"] = activeProjectId.value;
    map["project_id"] = 30;

    AddressListRepository().getAddressList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          AddressListResponse response =
              AddressListResponse.fromJson(jsonDecode(responseModel.result!));
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

  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    listItems.add(ModuleInfo(name: 'add'.tr, action: AppConstants.action.add));
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
    } else if (info.action == AppConstants.action.archivedProjects) {
      moveToScreen(AppRoutes.archiveProjectListScreen, null);
    }
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated.value = true;
      getProjectListApi();
    }
  }
}
