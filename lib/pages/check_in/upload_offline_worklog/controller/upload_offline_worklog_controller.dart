import 'dart:convert';

import 'package:belcka/pages/check_in/clock_in/controller/clock_in_utils.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:belcka/pages/check_in/upload_offline_worklog/model/offline_worklog_conflict_item.dart';
import 'package:belcka/pages/check_in/upload_offline_worklog/model/store_offline_work_response.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/pages/check_in/upload_offline_worklog/view/widgets/offline_worklog_conflict_bottom_sheet.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/pages/project/project_info/model/project_list_response.dart';
import 'package:belcka/pages/project/project_list/controller/project_list_repository.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/network/api_request.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadOfflineWorklogController extends GetxController
    implements SelectItemListener, DialogButtonClickListener {
  final RxBool isLoading = false.obs;
  final RxBool isMainViewVisible = false.obs;

  final projectController = TextEditingController().obs;
  final shiftController = TextEditingController().obs;

  final projectsList = <ProjectInfo>[].obs;
  final shiftsList = <ModuleInfo>[].obs;

  int selectedProjectId = 0;
  int selectedShiftId = 0;

  static const String _uploadDialogIdentifier = 'UPLOAD_OFFLINE_WORKLOG_DIALOG';

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
      print("selectedProjectId:" + selectedProjectId.toString());

      final selectedProject = projectsList.firstWhereOrNull(
          (project) => (project.id ?? 0) == selectedProjectId);
      shiftsList.value = selectedProject?.shifts ?? [];

      selectedShiftId = 0;
      shiftController.value.clear();
    } else if (action == AppConstants.dialogIdentifier.selectShift) {
      selectedShiftId = id;
      shiftController.value.text = name;
      print("selectedShiftId:" + selectedShiftId.toString());
    }
  }

  void onUploadButtonTap() {
    if (selectedProjectId == 0) {
      AppUtils.showToastMessage('please_select_project'.tr);
      return;
    }
    if (selectedShiftId == 0) {
      AppUtils.showToastMessage('please_select_shift'.tr);
      return;
    }
    showUploadConfirmationDialog();
  }

  void showUploadConfirmationDialog() {
    AlertDialogHelper.showAlertDialog(
      "",
      'upload_worklog_confirmation_message'.tr,
      'yes'.tr,
      'no'.tr,
      "",
      true,
      true,
      this,
      _uploadDialogIdentifier,
    );
  }

  Future<void> uploadOfflineWorklogsApi() async {
    final worklogs = await ClockInUtils.getOfflineRecordsUploadJson(
      selectedProjectId: selectedProjectId,
      selectedShiftId: selectedShiftId,
    );

    if (worklogs.isEmpty) {
      AppUtils.showToastMessage('empty_data_message'.tr);
      return;
    }

    print("selectedProjectId:" + selectedProjectId.toString());
    print("selectedShiftId:" + selectedShiftId.toString());

    final payload = <String, dynamic>{
      "user_id": UserUtils.getLoginUserId(),
      // "device_type": AppConstants.deviceType,
      // "device_model_type": await AppUtils.getDeviceName(),
      "start_device_type": AppConstants.deviceType,
      "start_device_model_type": await AppUtils.getDeviceName(),
      "end_device_type": AppConstants.deviceType,
      "end_device_model_type": await AppUtils.getDeviceName(),
      "worklogs": worklogs.map((row) {
        final int userWorklogId = (row["id"] as num?)?.toInt() ?? 0;
        final entry = <String, dynamic>{
          // shift_id / project_id are set in ClockInUtils: selected for id 0, log values for id > 0
          "shift_id": row["shift_id"],
          "project_id": row["project_id"],
          "work_start_time": row["work_start_time"],
          "start_work_location": row["start_work_location"] ?? {},
        };
        if (userWorklogId > 0) {
          entry["user_worklog_id"] = userWorklogId;
        }
        if (row.containsKey("work_end_time")) {
          entry["work_end_time"] = row["work_end_time"];
        }
        if (row.containsKey("stop_work_location")) {
          entry["stop_work_location"] = row["stop_work_location"];
        }
        return entry;
      }).toList(),
    };

    print("----");
    StringHelper.printLongString(payload.toString());
    print("----");

    isLoading.value = true;
    ApiRequest(url: ApiConstants.userStoreOfflineWork, data: payload)
        .postRequest(
      onSuccess: (data) {
        final responseModel = data as ResponseModel;
        _handleStoreOfflineWorkResponse(responseModel);
        isLoading.value = false;
      },
      onError: (error) {
        final responseModel = error as ResponseModel;
        isLoading.value = false;
        if (responseModel.statusCode ==
            ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (!StringHelper.isEmptyString(responseModel.statusMessage)) {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
      },
    );
  }

  void _handleStoreOfflineWorkResponse(ResponseModel responseModel) {
    if (!responseModel.isSuccess) {
      AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
      return;
    }

    final response = StoreOfflineWorkResponse.fromJson(
      jsonDecode(responseModel.result ?? "{}") as Map<String, dynamic>,
    );
    final message = response.message ?? "";

    if (response.data == null) {
      ClockInUtils.clearOfflineRecordsJson();
      AppUtils.showApiResponseMessage(message);
      Get.back(result: true);
      return;
    }

    final conflictData = response.data!;
    final hasConflictList = conflictData.conflicts?.isNotEmpty ?? false;
    if (conflictData.hasConflicts == true || hasConflictList) {
      if (!hasConflictList) {
        AppUtils.showApiResponseMessage(message);
        return;
      }
      final group = conflictData.conflicts!.first;
      final items = group.sheetItems();
      if (items.length < 2) {
        AppUtils.showApiResponseMessage(message);
        return;
      }
      final offlineStart = group.offlineWorklog?.startTime;
      if (!StringHelper.isEmptyString(offlineStart)) {
        ClockInUtils.retainOfflineWorklogsByStartTime(offlineStart!);
      }
      if (!StringHelper.isEmptyString(message)) {
        AppUtils.showApiResponseMessage(message);
      }
      showWorklogConflictBottomSheet(group);
      return;
    }

    ClockInUtils.clearOfflineRecordsJson();
    AppUtils.showApiResponseMessage(message);
    Get.back(result: true);
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == _uploadDialogIdentifier) {
      Get.back();
      uploadOfflineWorklogsApi();
    }
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onClose() {
    projectController.value.dispose();
    shiftController.value.dispose();
    super.onClose();
  }

  void onBackPress() {
    Get.offAllNamed(AppRoutes.dashboardScreen);
  }

  void showWorklogConflictBottomSheet(StoreOfflineWorkConflictGroup group) {
    final items = group.sheetItems();
    if (items.length < 2) return;
    if (Get.context == null) return;
    showOfflineWorklogConflictBottomSheet(
      context: Get.context!,
      items: items,
      projectsList: projectsList,
      onKeep: (index, item) {
        Get.back();
        keepOfflineWorklogApi(item, isOfflineEntry: index == 0);
      },
    );
  }

  Future<void> keepOfflineWorklogApi(
    OfflineWorklogConflictItem item, {
    required bool isOfflineEntry,
  }) async {
    final worklogEntry = _buildKeepWorklogEntry(item, isOfflineEntry: isOfflineEntry);

    final payload = <String, dynamic>{
      'user_id': UserUtils.getLoginUserId(),
      'start_device_type': AppConstants.deviceType,
      'start_device_model_type': await AppUtils.getDeviceName(),
      'end_device_type': AppConstants.deviceType,
      'end_device_model_type': await AppUtils.getDeviceName(),
      'worklogs': [worklogEntry],
    };

    isLoading.value = true;
    ApiRequest(url: ApiConstants.userKeepOfflineWork, data: payload).postRequest(
      onSuccess: (data) {
        final responseModel = data as ResponseModel;
        if (responseModel.isSuccess) {
          final response = BaseResponse.fromJson(
            jsonDecode(responseModel.result ?? '{}') as Map<String, dynamic>,
          );
          AppUtils.showApiResponseMessage(
            response.Message ?? responseModel.statusMessage ?? '',
          );
          ClockInUtils.clearOfflineRecordsJson();
          Get.back(result: true);
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? '');
        }
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        final responseModel = error as ResponseModel;
        if (responseModel.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (!StringHelper.isEmptyString(responseModel.statusMessage)) {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? '');
        }
      },
    );
  }

  Map<String, dynamic> _buildKeepWorklogEntry(
    OfflineWorklogConflictItem item, {
    required bool isOfflineEntry,
  }) {
    var entry = item.toKeepWorklogJson();
    if (!isOfflineEntry) return entry;

    final local = _localOfflineLogMatching(item.startTime);
    if (local == null) return entry;

    final keptId = (entry['user_worklog_id'] as num?)?.toInt() ?? 0;
    if (keptId == 0 && (local.id ?? 0) > 0) {
      entry['user_worklog_id'] = local.id;
    }
    if (!entry.containsKey('work_end_time') &&
        !StringHelper.isEmptyString(local.workEndTime)) {
      entry['work_end_time'] = local.workEndTime;
    }
    if (!entry.containsKey('start_work_location') &&
        local.startWorkLocation != null) {
      entry['start_work_location'] = local.startWorkLocation!.toJson();
    }
    if (!entry.containsKey('stop_work_location') &&
        local.stopWorkLocation != null) {
      entry['stop_work_location'] = local.stopWorkLocation!.toJson();
    }
    return entry;
  }

  WorkLogInfo? _localOfflineLogMatching(String? startTime) {
    if (StringHelper.isEmptyString(startTime)) return null;
    final logs =
        Get.find<AppStorage>().getWorklogDataOffline().workLogInfo ?? <WorkLogInfo>[];
    for (final log in logs) {
      if ((log.workStartTime ?? '') == startTime) return log;
    }
    return null;
  }
}
