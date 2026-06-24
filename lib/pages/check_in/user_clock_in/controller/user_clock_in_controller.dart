import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/check_in/clock_in/model/user_billing_info_validation_response.dart';
import 'package:belcka/pages/check_in/select_shift/model/start_work_response.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:belcka/pages/check_in/dialogs/select_project_bottom_dialog.dart';
import 'package:belcka/pages/check_in/dialogs/select_shift_dialog.dart';
import 'package:belcka/pages/check_in/dialogs/stop_work_confirm_dialog.dart';
import 'package:belcka/pages/check_in/user_clock_in/controller/user_clock_in_repository.dart';
import 'package:belcka/pages/check_in/user_clock_in/controller/user_clock_in_utils.dart';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/pages/project/project_info/model/project_list_response.dart';
import 'package:belcka/pages/project/project_list/controller/project_list_repository.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/counter_details.dart';
import 'package:belcka/pages/check_in/clock_in/model/location_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_list_response.dart';
import 'package:belcka/pages/check_in/select_shift/controller/select_shift_repository.dart';
import 'package:belcka/pages/dashboard/models/dashboard_response.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/model/form_submission_status_response.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/location_service_new.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';

class UserClockInController extends GetxController
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
  final _api = UserClockInRepository();
  late GoogleMapController mapController;
  final center =
      LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude).obs;
  final dashboardResponse = DashboardResponse().obs;
  final formSubmissionStatusResponse = FormSubmissionStatusResponse().obs;
  String? latitude, longitude, location, shiftId;
  bool fromStartShiftScreen = false;
  final locationService = LocationServiceNew();
  final workLogData = WorkLogListResponse().obs;
  WorkLogInfo? selectedWorkLogInfo = null;
  CheckLogInfo? selectedCheckLogInfo = null;
  Timer? _timer;
  final ScrollController scrollController = ScrollController();
  List<ProjectInfo> _projectsList = [];
  bool _switchProjectFlow = false;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      fromStartShiftScreen =
          arguments[AppConstants.intentKey.fromStartShiftScreen] ?? false;
    }
    shiftId = Get.find<AppStorage>().getShiftId();

    if (UserClockInUtils.hasOfflineRecordsForUpload()) {
      showUploadOfflineDataDialog();
    } else {
      LocationInfo? locationInfo = Get.find<AppStorage>().getLastLocation();
      if (locationInfo != null) {
        setLocation(double.parse(locationInfo.latitude ?? "0"),
            double.parse(locationInfo.longitude ?? "0"));
      }

      locationRequest();
      appLifeCycle();
      getUserWorkLogListApi();
    }
  }

  void getFormSubmissionStatusApi({bool? isSwitchProject}) {
    isLoading.value = true;
    _api.getFormSubmissionStatus(
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess && responseModel.result != null) {
          formSubmissionStatusResponse.value =
              FormSubmissionStatusResponse.fromJson(
            jsonDecode(responseModel.result!) as Map<String, dynamic>,
          );
          if (formSubmissionStatusResponse.value.userCanStartWork ?? false) {
            if (isSwitchProject ?? false) {
              _onSwitchProjectPressed();
            } else {
              userBillingInfoValidationAPI(isStartWorkClick: true);
            }
          } else {
            AppUtils.showToastMessage('all_forms_not_submitted'.tr);
            var arguments = {AppConstants.intentKey.fromStartWorkClick: true};
            moveToScreen(AppRoutes.formsListScreen, arguments);
          }
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        }
      },
    );
  }

  Future<void> userStartWorkApi({int? shiftId, int? projectId}) async {
    String deviceModelName = await AppUtils.getDeviceName();
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["shift_id"] = shiftId ?? workLogData.value.shiftId ?? 0;
    final pid = projectId ?? workLogData.value.projectId ?? 0;
    if (pid > 0) map["project_id"] = pid;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["location"] = location;
    map["device_type"] = AppConstants.deviceType;
    map["device_model_type"] = deviceModelName;
    SelectShiftRepository().userStartWork(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          StartWorkResponse response =
              StartWorkResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isRateApproved == null ||
              (response.isRateApproved ?? false)) {
            getUserWorkLogListApi();
          } else {
            AppUtils.showApiResponseMessage('rate_not_added_or_approved'.tr);
            AppUtils.moveToRateScreen();
          }
        } else {
          // AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          // isInternetNotAvailable.value = true;
          AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  Future<void> userStopWorkApi(
      {bool openProjectSelectionAfterStop = false}) async {
    String deviceModelName = await AppUtils.getDeviceName();
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["user_worklog_id"] = selectedWorkLogInfo?.id ?? 0;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["location"] = location;
    map["device_type"] = AppConstants.deviceType;
    map["device_model_type"] = deviceModelName;
    _api.userStopWork(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          getUserWorkLogListApi();
          if (openProjectSelectionAfterStop) {
            openProjectSelectionFlow();
          } else {
            moveToUserStopShift(selectedWorkLogInfo?.id);
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          // isInternetNotAvailable.value = true;
          AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  Future<void> getUserWorkLogListApi({bool? isProgress}) async {
    print("getUserWorkLogListApi clock in");
    isLoading.value = isProgress ?? true;
    Map<String, dynamic> map = {};
    map["date"] = "";
    map["shift_id"] = 0;
    _api.getUserWorkLogList(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          WorkLogListResponse response =
              WorkLogListResponse.fromJson(jsonDecode(responseModel.result!));
          Get.find<AppStorage>().setWorklogData(response);
          Get.find<AppStorage>().setWorklogDataOffline(response);
          // WorkLogListResponse response =
          //     WorkLogListResponse.fromJson(jsonDecode(DataUtils.workResponse));

          workLogData.value = response;
          if (UserClockInUtils.isCurrentDay(
              workLogData.value.workStartDate ?? "")) {
            workLogData.value.workLogInfo!.add(WorkLogInfo(id: 0));
          }

          selectedWorkLogInfo = null;
          for (var info in workLogData.value.workLogInfo!) {
            if (StringHelper.isEmptyString(info.workEndTime) &&
                (info.id ?? 0) != 0) {
              selectedWorkLogInfo = info;
              break;
            }
          }
          selectedCheckLogInfo = null;
          if (response.userIsWorking ?? false) {
            isChecking.value = false;
            if (selectedWorkLogInfo != null &&
                selectedWorkLogInfo!.userChecklogs != null) {
              for (var checkInInfo in selectedWorkLogInfo!.userChecklogs!) {
                if (StringHelper.isEmptyString(checkInInfo.checkoutDateTime)) {
                  selectedCheckLogInfo = checkInInfo;
                  isChecking.value = true;
                  break;
                }
              }
            }

            stopTimer();
            startTimer();

            scrollToBottom();
          } else {
            isChecking.value = false;
            print("isChecking.value:" + isChecking.value.toString());
            stopTimer();
            CounterDetails details =
                UserClockInUtils.getTotalWorkHours(workLogData.value);
            totalWorkHours.value = details.totalWorkTime;
            activeWorkHours.value = DateUtil.seconds_To_HH_MM_SS(0);
            isOnBreak.value = details.isOnBreak;
            isOnLeave.value = details.isOnLeave;
            remainingBreakTime.value = details.remainingBreakTime;
            remainingLeaveTime.value = details.remainingLeaveTime;
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          // isInternetNotAvailable.value = true;
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  Future<void> userBillingInfoValidationAPI(
      {required bool isStartWorkClick}) async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.userBillingInfoValidation(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          UserBillingInfoValidationResponse response =
              UserBillingInfoValidationResponse.fromJson(
                  jsonDecode(responseModel.result!));
          if (response.isBillingInfoCompleted ?? false) {
            if (isStartWorkClick) {
              openProjectSelectionFlow();
            } else {
              userStartWorkApi();
            }
          } else {
            AlertDialogHelper.showEmptyBillingInfoWarningDialog(
              phoneWithExtension: response.phoneWithExtension ?? "",
              onContactTap: () {
                AppUtils.onClickPhoneNumber(response.phoneWithExtension ?? "");
              },
            );
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          // isInternetNotAvailable.value = true;
          AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  void appLifeCycle() {
    AppLifecycleListener(
      onResume: () async {
        if (!isLocationLoaded.value) locationRequest();
      },
    );
  }

  Future<void> locationRequest() async {
    bool isLocationLoaded = await locationService.checkLocationService();
    if (isLocationLoaded) {
      fetchLocationAndAddress();
    }
  }

  Future<void> fetchLocationAndAddress() async {
    Position? latLon = await LocationServiceNew.getCurrentLocation();
    if (latLon != null) {
      isLocationLoaded.value = true;
      setLocation(latLon.latitude, latLon.longitude);
    }
  }

  Future<void> setLocation(double? lat, double? lon) async {
    if (lat != null && lon != null) {
      latitude = lat.toString();
      longitude = lon.toString();
      center.value = LatLng(lat, lon);
      location = await LocationServiceNew.getAddressFromCoordinates(lat, lon);
      /* mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center.value, zoom: 15),
      ));*/
      print("Location:" + "Latitude: ${latitude}, Longitude: ${longitude}");
      print("Address:${location ?? ""}");
    }
  }

  void openProjectSelectionFlow({bool switchProject = false}) {
    _switchProjectFlow = switchProject;
    getProjectListApi(showSheetOnSuccess: true);
  }

  void getProjectListApi({bool showSheetOnSuccess = false}) {
    isLoading.value = true;
    final Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;

    ProjectListRepository().getProjectList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess) {
          final response = ProjectListResponse.fromJson(
              jsonDecode(responseModel.result!) as Map<String, dynamic>);
          _projectsList = response.info ?? [];
          if (showSheetOnSuccess) {
            if (_projectsList.isEmpty) {
              AppUtils.showToastMessage('empty_data_message'.tr);
            } else {
              _showProjectBottomSheet();
            }
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
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

  void _showProjectBottomSheet() {
    Get.bottomSheet(
      SelectProjectBottomDialog(
        projects: _projectsList,
        onProjectSelected: _onProjectSelected,
        onCancel: () => Get.back(),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void _onProjectSelected(ProjectInfo project) {
    Get.back();
    final shifts = project.shifts ?? [];
    if (shifts.length == 1) {
      _completeProjectShiftSelection(shifts.first.id ?? 0, project.id ?? 0);
    } else if (shifts.isEmpty) {
      AppUtils.showToastMessage('empty_data_message'.tr);
    } else {
      _showShiftBottomSheet(project, shifts);
    }
  }

  void _showShiftBottomSheet(ProjectInfo project, List<ModuleInfo> shifts) {
    Get.bottomSheet(
      SelectShiftDialog(
        selectedProjectName: project.name ?? '',
        shifts: shifts,
        onShiftSelected: (shift) {
          Get.back();
          _completeProjectShiftSelection(shift.id ?? 0, project.id ?? 0);
        },
        onBack: () {
          Get.back();
          _showProjectBottomSheet();
        },
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Future<void> _completeProjectShiftSelection(
      int shiftId, int projectId) async {
    if (_switchProjectFlow) {
      await userStopWorkAndStartWork(shiftId, projectId);
    } else {
      await userStartWorkApi(shiftId: shiftId, projectId: projectId);
    }
    _switchProjectFlow = false;
  }

  Future<void> userStopWorkAndStartWork(int shiftId, int projectId) async {
    String deviceModelName = await AppUtils.getDeviceName();
    isLoading.value = true;
    final Map<String, dynamic> map = {};
    map["user_worklog_id"] = selectedWorkLogInfo?.id ?? 0;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["location"] = location;
    map["device_type"] = AppConstants.deviceType;
    map["device_model_type"] = deviceModelName;
    _api.userStopWork(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          userStartWorkApi(shiftId: shiftId, projectId: projectId);
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
          isLoading.value = false;
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  onClickStartShiftButton({dynamic arguments}) {
    bool switchProject = false;
    if (arguments != null) {
      switchProject = arguments[AppConstants.intentKey.switchProject] ?? false;
    }
    openProjectSelectionFlow(switchProject: switchProject);
  }

  onClickAddExpense(int workLogId) async {
    var result;
    var arguments = {
      AppConstants.intentKey.userId: UserUtils.getLoginUserId(),
      AppConstants.intentKey.workLogId: workLogId,
      AppConstants.intentKey.projectId: workLogData.value.projectId ?? 0,
      AppConstants.intentKey.projectName: workLogData.value.projectName ?? 0,
    };
    result =
        await Get.toNamed(AppRoutes.addExpenseScreen, arguments: arguments);
    if (result != null) {
      getUserWorkLogListApi();
    }
  }

  void _onSwitchProjectPressed() {
    openProjectSelectionFlow(switchProject: true);
  }

  onCLickCheckInButton() {
    if (workLogData.value.isCheckIn ?? false) {
      var arguments = {
        AppConstants.intentKey.workLogId: selectedWorkLogInfo?.id ?? 0,
        AppConstants.intentKey.projectId: selectedWorkLogInfo?.projectId ?? 0,
        AppConstants.intentKey.isPriceWork:
            selectedWorkLogInfo?.isPricework ?? false
      };
      moveToScreen(AppRoutes.checkInScreen, arguments);
    }
  }

  onCLickCheckOutButton() {
    var arguments = {
      AppConstants.intentKey.checkLogId: selectedCheckLogInfo?.id ?? 0,
      AppConstants.intentKey.workLogId: selectedWorkLogInfo?.id ?? 0,
      AppConstants.intentKey.projectId: selectedWorkLogInfo?.projectId ?? 0,
      AppConstants.intentKey.isPriceWork:
          selectedWorkLogInfo?.isPricework ?? false
    };
    moveToScreen(AppRoutes.checkOutScreen, arguments);
  }

  String getCurrentLogPayableTime() {
    if (workLogData.value.userIsWorking ?? false) {
      return activeWorkHours.value.isNotEmpty
          ? activeWorkHours.value
          : totalWorkHours.value;
    }
    return DateUtil.seconds_To_HH_MM_SS(
        selectedWorkLogInfo?.payableWorkSeconds ?? 0);
  }

  void showStopWorkConfirmDialog() {
    Get.dialog(
      StopWorkConfirmDialog(
        workedTime: getCurrentLogPayableTime(),
        onCancel: () => Get.back(),
        onConfirm: () {
          Get.back();
          userStopWorkApi();
        },
      ),
      barrierDismissible: true,
    );
  }

  onClickStopShiftButton() async {
    showStopWorkConfirmDialog();
  }

  List<CheckLogInfo> _checkLogsForWorkLog(int? worklogId) {
    if (worklogId == null || worklogId == 0) return [];
    for (final info in workLogData.value.workLogInfo ?? []) {
      if (info.id == worklogId) {
        return List<CheckLogInfo>.from(info.userChecklogs ?? []);
      }
    }
    if (selectedWorkLogInfo?.id == worklogId) {
      return List<CheckLogInfo>.from(selectedWorkLogInfo?.userChecklogs ?? []);
    }
    return [];
  }

  Map<String, dynamic> _userStopShiftArguments(int? worklogId) {
    return {
      AppConstants.intentKey.workLogId: worklogId ?? 0,
      AppConstants.intentKey.userCheckLogs: _checkLogsForWorkLog(worklogId),
    };
  }

  moveToUserStopShift(int? worklogId) async {
    var result = await Get.toNamed(
      AppRoutes.userStopShiftScreen,
      arguments: _userStopShiftArguments(worklogId),
    );
    print("result:" + result.toString());
    if (result != null && result) {
      getUserWorkLogListApi();
    }
  }

  onClickWorkLogItem(int? worklogId) async {
    var result = await Get.toNamed(
      AppRoutes.stopShiftScreen,
      arguments: _userStopShiftArguments(worklogId),
    );

    print("result:" + result.toString());
    if (result != null && result) {
      getUserWorkLogListApi();
    }
  }

  moveToScreen(String path, dynamic arguments) async {
    var result = await Get.toNamed(path, arguments: arguments);
    if (result != null && result) {
      getUserWorkLogListApi();
    }
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
    CounterDetails details =
        UserClockInUtils.getTotalWorkHours(workLogData.value);
    totalWorkHours.value = details.totalWorkTime;
    activeWorkHours.value =
        DateUtil.seconds_To_HH_MM_SS(details.activeWorkSeconds);
    isOnBreak.value = details.isOnBreak;
    isOnLeave.value = details.isOnLeave;
    remainingBreakTime.value = details.remainingBreakTime;
    remainingLeaveTime.value = details.remainingLeaveTime;
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
      onCLickCheckOutButton();
    } else if (dialogIdentifier ==
        AppConstants.dialogIdentifier.offlineWorklogDatUpload) {
      Get.back();
      moveToScreen(AppRoutes.uploadOfflineWorklogScreen, null);
    }
  }

  void showUploadOfflineDataDialog() {
    AlertDialogHelper.showAlertDialog(
        "",
        'offline_worklog_data_available_message'.tr,
        'upload'.tr,
        "",
        "",
        false,
        false,
        this,
        AppConstants.dialogIdentifier.offlineWorklogDatUpload);
  }

  @override
  void onClose() {
    stopTimer();
    scrollController.dispose();
    super.onClose();
  }

  void onBackPress() {
    if (fromStartShiftScreen) {
      Get.offAllNamed(AppRoutes.dashboardScreen);
    } else {
      Get.back();
    }
  }
}
