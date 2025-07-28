import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/check_log_details/controller/check_log_details_repository.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/model/work_log_details_response.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class CheckLogDetailsController extends GetxController {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final RxString totalWorkHours = "".obs,
      remainingBreakTime = "".obs,
      activeWorkHours = "".obs;
  final _api = CheckLogDetailsRepository();
  final workInfo = WorkLogInfo().obs;
  int workLogId = 0;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null && arguments is Map) {
      workLogId = arguments[AppConstants.intentKey.workLogId] ?? 0;
    }

    getCheckLogDetailsApi();
  }

  Future<void> getCheckLogDetailsApi() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["worklog_id"] = workLogId;
    _api.getCheckLogDetails(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          WorkLogDetailsResponse response = WorkLogDetailsResponse.fromJson(
              jsonDecode(responseModel.result!));
          workInfo.value = response.info!;
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
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

  onClickWorkLogItem(WorkLogInfo info) async {
    var arguments = {AppConstants.intentKey.workLogId: info.id ?? 0};
    var result =
        await Get.toNamed(AppRoutes.stopShiftScreen, arguments: arguments);
    print("result:" + result.toString());
    if (result != null && result) {
      // getUserWorkLogListApi();
    }
  }

  moveToScreen(String path, dynamic arguments) async {
    var result = await Get.toNamed(path, arguments: arguments);
    if (result != null && result) {
      // getUserWorkLogListApi();
    }
  }

  String changeFullDateToSortTime(String? date) {
    return !StringHelper.isEmptyString(date)
        ? DateUtil.changeDateFormat(
            date!, DateUtil.DD_MM_YYYY_TIME_24_SLASH2, DateUtil.HH_MM_24)
        : "";
  }

  void _onTick(Timer? timer) {
    /*   CounterDetails details = ClockInUtils.getTotalWorkHours(workLogData.value);
    totalWorkHours.value = details.totalWorkTime;
    activeWorkHours.value =
        DateUtil.seconds_To_HH_MM_SS(details.activeWorkSeconds);
    isOnBreak.value = details.isOnBreak;
    remainingBreakTime.value = details.remainingBreakTime;*/
  }
}
