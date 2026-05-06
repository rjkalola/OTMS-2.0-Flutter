import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/pages/project/project_info/model/project_list_response.dart';
import 'package:belcka/pages/project/project_list/controller/project_list_repository.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadOfflineWorklogController extends GetxController
    implements SelectItemListener {
  final RxBool isLoading = false.obs;
  final RxBool isMainViewVisible = false.obs;

  final projectController = TextEditingController().obs;
  final shiftController = TextEditingController().obs;

  final projectsList = <ProjectInfo>[].obs;
  final shiftsList = <ModuleInfo>[].obs;

  int selectedProjectId = 0;
  int selectedShiftId = 0;

  @override
  void onInit() {
    super.onInit();
    getProjectListApi();
  }

  void getProjectListApi() {
    isLoading.value = true;

    final Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;

    ProjectListRepository().getProjectList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          final response =
              ProjectListResponse.fromJson(jsonDecode(responseModel.result!));
          projectsList.value = response.info ?? [];
          isMainViewVisible.value = true;
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (!StringHelper.isEmptyString(error.statusMessage)) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void showSelectProjectDialog() {
    if (projectsList.isEmpty) {
      AppUtils.showToastMessage('empty_data_message'.tr);
      return;
    }
    final List<ModuleInfo> list = projectsList
        .map((project) => ModuleInfo(id: project.id ?? 0, name: project.name))
        .toList();
    showDropDownDialog(
      AppConstants.dialogIdentifier.selectProject,
      'Select Project',
      list,
      this,
    );
  }

  void showSelectShiftDialog() {
    if (selectedProjectId == 0) {
      AppUtils.showToastMessage('Please select project first');
      return;
    }
    if (shiftsList.isEmpty) {
      AppUtils.showToastMessage('empty_data_message'.tr);
      return;
    }
    showDropDownDialog(
      AppConstants.dialogIdentifier.selectShift,
      'Select Shift',
      shiftsList,
      this,
    );
  }

  void showDropDownDialog(
    String dialogType,
    String title,
    List<ModuleInfo> list,
    SelectItemListener listener,
  ) {
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
      isScrollControlled: true,
    );
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectProject) {
      selectedProjectId = id;
      projectController.value.text = name;

      final selectedProject = projectsList
          .firstWhereOrNull((project) => (project.id ?? 0) == selectedProjectId);
      shiftsList.value = selectedProject?.shifts ?? [];

      selectedShiftId = 0;
      shiftController.value.clear();
    } else if (action == AppConstants.dialogIdentifier.selectShift) {
      selectedShiftId = id;
      shiftController.value.text = name;
    }
  }

  @override
  void onClose() {
    projectController.value.dispose();
    shiftController.value.dispose();
    super.onClose();
  }

  void onBackPress() {
    Get.offAllNamed(AppRoutes.dashboardScreen);
  }
}
