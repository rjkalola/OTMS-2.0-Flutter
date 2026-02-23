import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/check_in/clock_in/model/user_billing_info_validation_response.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:belcka/pages/check_in/clock_in/controller/clock_in_repository.dart';
import 'package:belcka/pages/check_in/clock_in/controller/clock_in_utils.dart';
import 'package:belcka/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/counter_details.dart';
import 'package:belcka/pages/check_in/clock_in/model/location_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_list_response.dart';
import 'package:belcka/pages/check_in/clock_in2/model/start_work_response.dart';
import 'package:belcka/pages/check_in/select_shift/controller/select_shift_repository.dart';
import 'package:belcka/pages/dashboard/models/dashboard_response.dart';
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

class ClockInController extends GetxController
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
  final _api = ClockInRepository();
  late GoogleMapController mapController;
  final center =
      LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude).obs;
  final dashboardResponse = DashboardResponse().obs;
  String? latitude, longitude, location, shiftId;
  final locationService = LocationServiceNew();
  final workLogData = WorkLogListResponse().obs;
  WorkLogInfo? selectedWorkLogInfo = null;
  CheckLogInfo? selectedCheckLogInfo = null;
  Timer? _timer;
  final ScrollController scrollController = ScrollController();

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
      // fromSignUp.value =
      //     arguments[AppConstants.intentKey.fromSignUpScreen] ?? "";
    }
    shiftId = Get.find<AppStorage>().getShiftId();

    LocationInfo? locationInfo = Get.find<AppStorage>().getLastLocation();
    if (locationInfo != null) {
      setLocation(double.parse(locationInfo.latitude ?? "0"),
          double.parse(locationInfo.longitude ?? "0"));
    }

    locationRequest();
    appLifeCycle();
    getUserWorkLogListApi();
  }

  Future<void> userStartWorkApi() async {
    String deviceModelName = await AppUtils.getDeviceName();
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["shift_id"] = workLogData.value.shiftId ?? 0;
    map["project_id"] = workLogData.value.projectId ?? 0;
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
          getUserWorkLogListApi();
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

  Future<void> userStopWorkApi() async {
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
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          // AppUtils.showApiResponseMessage(response.Message);
          getUserWorkLogListApi();
          onClickStartShiftButton();
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

          // WorkLogListResponse response =
          //     WorkLogListResponse.fromJson(jsonDecode(DataUtils.workResponse));

          workLogData.value = response;
          if (ClockInUtils.isCurrentDay(
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
                ClockInUtils.getTotalWorkHours(workLogData.value);
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
              onClickStartShiftButton();
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

  onClickStartShiftButton({dynamic arguments}) async {
    var result;
    result =
        await Get.toNamed(AppRoutes.selectProjectScreen, arguments: arguments);
    if (result != null) {
      getUserWorkLogListApi();
    }
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

  onCLickCheckInButton() {
    var arguments = {
      AppConstants.intentKey.workLogId: selectedWorkLogInfo?.id ?? 0,
      AppConstants.intentKey.projectId: selectedWorkLogInfo?.projectId ?? 0,
      AppConstants.intentKey.isPriceWork:
          selectedWorkLogInfo?.isPricework ?? false
    };
    moveToScreen(AppRoutes.checkInScreen, arguments);
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

  onClickStopShiftButton() async {
    userStopWorkApi();
  }

  onClickWorkLogItem(WorkLogInfo info) async {
    var arguments = {AppConstants.intentKey.workLogId: info.id ?? 0};
    var result =
        await Get.toNamed(AppRoutes.stopShiftScreen, arguments: arguments);
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
    CounterDetails details = ClockInUtils.getTotalWorkHours(workLogData.value);
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
    }
  }

  @override
  void onClose() {
    print("onClose");
    stopTimer();
    scrollController.dispose();
    super.onClose();
  }

  void onBackPress() {
    Get.back();
  }
}
