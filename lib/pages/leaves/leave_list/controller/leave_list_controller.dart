import 'dart:convert';

import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/leaves/leave_list/controller/leave_list_repository.dart';
import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';
import 'package:belcka/pages/leaves/leave_list/model/leave_list_response.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../web_services/api_constants.dart';

class LeaveListController extends GetxController implements MenuItemListener {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isAllLeaves = false.obs;
  final RxInt selectedDateFilterIndex = (2).obs;
  final _api = LeaveListRepository();
  final listItems = <LeaveInfo>[].obs;
  int selectedIndex = 0, userId = 0;
  String startDate = "", endDate = "";
  RxString title = "".obs, displayStartDate = "".obs, displayEndDate = "".obs;
  List<LeaveInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ?? 0;
      print("userId:$userId");
    }
    getLeaveListApi(true);
  }

  void getLeaveListApi(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["start_date"] = startDate;
    map["end_date"] = endDate;
    map["user_id"] = userId;
    map["all_leaves"] = isAllLeaves.value;

    _api.getLeaveList(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          LeaveListResponse response =
              LeaveListResponse.fromJson(jsonDecode(responseModel.result!));
          tempList.clear();
          tempList.addAll(response.data ?? []);
          listItems.value = tempList;
          listItems.refresh();
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
      getLeaveListApi(true);
    }
  }

  void clearFilter() {
    startDate = "";
    endDate = "";
    selectedDateFilterIndex.value = -1;
    getLeaveListApi(true);
  }

  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    listItems.add(ModuleInfo(name: 'add'.tr, action: AppConstants.action.add));
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  @override
  Future<void> onSelectMenuItem(ModuleInfo info, String dialogType) async {
    if (info.action == AppConstants.action.add) {
      var arguments = {AppConstants.intentKey.userId: userId};
      moveToScreen(AppRoutes.createLeaveScreen, arguments);
    }
  }
}
