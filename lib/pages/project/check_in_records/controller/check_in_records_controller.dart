import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/project/check_in_records/controller/check_in_records_repository.dart';
import 'package:belcka/pages/project/check_in_records/model/check_in_records_info.dart';
import 'package:belcka/pages/project/check_in_records/model/check_in_records_response.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';

import '../../../../web_services/api_constants.dart';

class CheckInRecordsController extends GetxController
    implements MenuItemListener {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isResetEnable = false.obs;
  final RxInt selectedDateFilterIndex = (0).obs;
  final _api = CheckInRecordsRepository();
  final listItems = <CheckInRecordsInfo>[].obs;
  int selectedIndex = 0, projectId = 0, addressId = 0;
  String filterPerDay = "", startDate = "", endDate = "";
  RxString title = "".obs;
  List<CheckInRecordsInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      projectId = arguments[AppConstants.intentKey.projectId] ?? 0;
      addressId = arguments[AppConstants.intentKey.addressId] ?? 0;
    }
    getProjectCheckLogsApi(true);
  }

  void getProjectCheckLogsApi(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["start_date"] = startDate;
    map["end_date"] = endDate;
    map["project_id"] = projectId;
    map["address_id"] = addressId;

    _api.getProjectCheckLogs(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          CheckInRecordsResponse response = CheckInRecordsResponse.fromJson(
              jsonDecode(responseModel.result!));
          tempList.clear();
          tempList.addAll(response.info ?? []);
          listItems.value = tempList;
          listItems.refresh();
          title.value = addressId != 0
              ? response.addressName ?? ""
              : response.projectName ?? "";
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        }
      },
    );
  }

  void showMenuItemsDialog(
      BuildContext context, List<ModuleInfo> listItems, String dialogType) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => MenuItemsListBottomDialog(
        list: listItems,
        listener: this,
        dialogType: dialogType,
      ),
    );
  }

  @override
  Future<void> onSelectMenuItem(ModuleInfo info, String dialogType) async {
    if (dialogType == AppConstants.dialogIdentifier.selectDayFilter) {
      isResetEnable.value = true;
      filterPerDay = info.name!.toLowerCase();
      getProjectCheckLogsApi(true);
    }
  }

  onClickWorkLogItem(int workLogId, int userId) async {
    // var arguments = {
    //   AppConstants.intentKey.workLogId: workLogId,
    //   AppConstants.intentKey.userId: userId
    // };
    // var result =
    //     await Get.toNamed(AppRoutes.stopShiftScreen, arguments: arguments);
    // print("result:" + result.toString());
    // if (result != null && result) {
    //   loadTimesheetData(true);
    // }
  }

  moveToScreen(String path, dynamic arguments) async {
    var result = await Get.toNamed(path, arguments: arguments);
    if (result != null && result) {
      getProjectCheckLogsApi(true);
    }
  }

  void clearFilter() {
    isResetEnable.value = false;
    filterPerDay = "";
    startDate = "";
    endDate = "";
    selectedDateFilterIndex.value = -1;
    getProjectCheckLogsApi(true);
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(Duration(milliseconds: 100), () {
      AppUtils.setStatusBarColor();
    });
  }
}
