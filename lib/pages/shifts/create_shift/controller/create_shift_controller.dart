import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/listener/select_time_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/shifts/create_shift/controller/create_shift_repository.dart';
import 'package:belcka/pages/shifts/create_shift/model/break_info.dart';
import 'package:belcka/pages/shifts/create_shift/model/shift_info.dart';
import 'package:belcka/pages/shifts/create_shift/model/week_day_info.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';

class CreateShiftController extends GetxController
    implements SelectTimeListener, DialogButtonClickListener, MenuItemListener {
  final shiftNameController = TextEditingController().obs;

  final formKey = GlobalKey<FormState>();
  final _api = CreateShiftRepository();

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSaveEnable = false.obs;
  final breaksList = <BreakInfo>[].obs;
  final weekDaysList = <WeekDayInfo>[].obs;
  final removeBreakIdsList = <String>[].obs;
  final shiftInfo = ShiftInfo().obs;
  int selectedBreakPosition = 0;
  final title = ''.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      shiftInfo.value = ShiftInfo().copyShiftInfo(
          shiftInfo: arguments[AppConstants.intentKey.shiftInfo]);
      setInitData();
    } else {
      title.value = 'create_new_shift'.tr;
      isSaveEnable.value = true;
      shiftInfo.value.companyId = ApiConstants.companyId;
      weekDaysList.addAll(DataUtils.getWeekDays());
      shiftInfo.value.startTime = "08:00";
      shiftInfo.value.endTime = "15:00";
      shiftInfo.value.isPricework = false;
    }
  }

  void setInitData() {
    title.value = 'edit_shift'.tr;
    shiftNameController.value.text = shiftInfo.value.name ?? "";
    for (var info in shiftInfo.value.weekDays ?? []) {
      weekDaysList.add(WeekDayInfo().copyWeekDayInfo(info: info));
    }
    weekDaysList.refresh();
    breaksList.addAll(shiftInfo.value.breaks ?? []);

    // supervisorId = teamInfo?.supervisorId ?? 0;
    // teamMembersList.addAll(teamInfo?.teamMembers ?? []);
  }

  void createShiftApi() async {
    if (valid()) {
      // Map<String, dynamic> map = {};
      // map["company_id"] = ApiConstants.companyId;
      // map["supervisor_id"] = supervisorId;
      // map["name"] = StringHelper.getText(teamNameController.value);
      // map["team_member_ids"] =
      //     UserUtils.getCommaSeparatedIdsString(teamMembersList);
      isLoading.value = true;
      _api.addShift(
        data: jsonEncode(shiftInfo),
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

  void editShiftApi() async {
    if (valid()) {
      // Map<String, dynamic> map = {};
      // map["company_id"] = ApiConstants.companyId;
      // map["supervisor_id"] = supervisorId;
      // map["name"] = StringHelper.getText(teamNameController.value);
      // map["team_member_ids"] =
      //     UserUtils.getCommaSeparatedIdsString(teamMembersList);
      isLoading.value = true;
      _api.editShift(
        data: jsonEncode(shiftInfo),
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

  void deleteShiftApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["shift_id"] = shiftInfo.value.id ?? 0;
    _api.deleteShift(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message);
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

  void archiveShiftApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    // map["company_id"] = ApiConstants.companyId;
    map["shift_id"] = shiftInfo.value.id ?? 0;
    _api.archiveShift(
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

  showDeleteShiftDialog() async {
    AlertDialogHelper.showAlertDialog(
        "",
        'are_you_sure_you_want_to_delete'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.deleteShift);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.deleteShift) {
      archiveShiftApi();
      // deleteShiftApi();
      Get.back();
    }
  }

  bool valid() {
    return formKey.currentState!.validate();
  }

  void clearBreaks() {
    isSaveEnable.value = true;
    for (var info in breaksList) {
      if ((info.breakId ?? 0) > 0) {
        removeBreakIdsList.add(info.breakId.toString());
      }
    }
    breaksList.clear();
    breaksList.refresh();
  }

  void addBreak() {
    isSaveEnable.value = true;
    breaksList.add(getDefaultBreakInfo());
    breaksList.refresh();
  }

  BreakInfo getDefaultBreakInfo() {
    return BreakInfo(
        breakId: 0, breakStartTime: "12:00", breakEndTime: "13:00");
  }

  void showTimePickerDialog(String dialogIdentifier, DateTime? time) {
    DateUtil.showTimePickerDialog(
        initialTime: time,
        dialogIdentifier: dialogIdentifier,
        selectTimeListener: this);
  }

  @override
  void onSelectTime(DateTime time, String dialogIdentifier) {
    isSaveEnable.value = true;
    if (dialogIdentifier ==
        AppConstants.dialogIdentifier.selectShiftStartTime) {
      shiftInfo.value.startTime =
          DateUtil.timeToString(time, DateUtil.HH_MM_24);
    } else if (dialogIdentifier ==
        AppConstants.dialogIdentifier.selectShiftEndTime) {
      shiftInfo.value.endTime = DateUtil.timeToString(time, DateUtil.HH_MM_24);
    } else if (dialogIdentifier ==
        AppConstants.dialogIdentifier.selectBreakStartTime) {
      breaksList[selectedBreakPosition].breakStartTime =
          DateUtil.timeToString(time, DateUtil.HH_MM_24);
    } else if (dialogIdentifier ==
        AppConstants.dialogIdentifier.selectBreakEndTime) {
      breaksList[selectedBreakPosition].breakEndTime =
          DateUtil.timeToString(time, DateUtil.HH_MM_24);
    }
    shiftInfo.refresh();
  }

  void onSubmit() {
    if (isSaveEnable.value) {
      if (valid()) {
        shiftInfo.value.name = StringHelper.getText(shiftNameController.value);
        shiftInfo.value.breaks = breaksList;
        shiftInfo.value.weekDays = weekDaysList;
        shiftInfo.value.removeBreakIds =
            StringHelper.getCommaSeparatedStringIds(removeBreakIdsList);
        if ((shiftInfo.value.id ?? 0) > 0) {
          editShiftApi();
        } else {
          createShiftApi();
        }
      }
    }
  }

  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    // listItems.add(ModuleInfo(
    //     name: 'archive'.tr, action: AppConstants.action.archiveShift));
    listItems
        .add(ModuleInfo(name: 'archive'.tr, action: AppConstants.action.delete));
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  @override
  Future<void> onSelectMenuItem(ModuleInfo info,String dialogType) async {
    if (info.action == AppConstants.action.delete) {
      showDeleteShiftDialog();
    } else if (info.action == AppConstants.action.archiveShift) {
      archiveShiftApi();
    }
  }

  @override
  void dispose() {
    Get.delete<CreateShiftController>();
    super.dispose();
  }
}
