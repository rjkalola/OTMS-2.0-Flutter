import 'dart:async';

import 'package:belcka/pages/check_in/clock_in/controller/clock_in_utils.dart';
import 'package:belcka/pages/check_in/clock_in/model/counter_details.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_list_response.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:get/get.dart';

class ClockInOfflineController extends GetxController
    implements DialogButtonClickListener {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isLocationLoaded = false.obs,
      isOnBreak = false.obs,
      isOnLeave = false.obs,
      isChecking = false.obs;
  final RxString totalWorkHours = "".obs,
      remainingBreakTime = "".obs,
      remainingLeaveTime = "".obs,
      activeWorkHours = "".obs;
  final WorkLogListResponse? workLogData = WorkLogListResponse();
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

  }

  String changeFullDateToSortTime(String? date) {
    return !StringHelper.isEmptyString(date)
        ? DateUtil.changeDateFormat(
            date!, DateUtil.DD_MM_YYYY_TIME_24_SLASH2, DateUtil.HH_MM_24)
        : "";
  }

  void startTimer() {
    _onTick(null);
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _onTick(timer);
    });
  }

  void _onTick(Timer? timer) {
    // CounterDetails details = ClockInUtils.getTotalWorkHours(workLogData.value);
    // totalWorkHours.value = details.totalWorkTime;
    // activeWorkHours.value =
    //     DateUtil.seconds_To_HH_MM_SS(details.activeWorkSeconds);
    // isOnBreak.value = details.isOnBreak;
    // isOnLeave.value = details.isOnLeave;
    // remainingBreakTime.value = details.remainingBreakTime;
    // remainingLeaveTime.value = details.remainingLeaveTime;
  }

  void stopTimer() {
    _timer?.cancel();
  }

  showCheckOutWarningDialog() async {
    AlertDialogHelper.showAlertDialog(
        "",
        'checkout_before_stop_work_message'.tr,
        'check_out_'.tr,
        'cancel'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.checkoutWarningDialog);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier ==
        AppConstants.dialogIdentifier.checkoutWarningDialog) {
      Get.back();

    }
  }

}
