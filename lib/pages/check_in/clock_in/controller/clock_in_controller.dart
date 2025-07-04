import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_repository.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_utils.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/counter_details.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_list_response.dart';
import 'package:otm_inventory/pages/dashboard/models/dashboard_response.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/location_service_new.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class ClockInController extends GetxController {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isLocationLoaded = false.obs,
      isOnBreak = false.obs;
  final RxString totalWorkHours = "".obs, remainingBreakTime = "".obs;
  final _api = ClockInRepository();
  late GoogleMapController mapController;
  final center = LatLng(37.42796133580664, -122.085749655962).obs;
  final dashboardResponse = DashboardResponse().obs;
  String? latitude, longitude, location, shiftId;
  final locationService = LocationServiceNew();
  final workLogData = WorkLogListResponse().obs;
  WorkLogInfo? selectedWorkLogInfo = null;
  Timer? _timer;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
    locationRequest();
    appLifeCycle();
    getUserWorkLogListApi();
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
          AppUtils.showApiResponseMessage(response.Message);
          getUserWorkLogListApi();
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

  Future<void> getUserWorkLogListApi() async {
    isLoading.value = true;
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
          if (response.userIsWorking ?? false) {
            stopTimer();
            startTimer();
          } else {
            stopTimer();
            CounterDetails details =
                ClockInUtils.getTotalWorkHours(workLogData.value);
            totalWorkHours.value = details.totalWorkTime;
            isOnBreak.value = details.isOnBreak;
            remainingBreakTime.value = details.remainingBreakTime;
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
      latitude = latLon.latitude.toString();
      longitude = latLon.longitude.toString();
      location = await LocationServiceNew.getAddressFromCoordinates(
          latLon.latitude, latLon.longitude);
      center.value = LatLng(latLon.latitude, latLon.longitude);
      /* mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center.value, zoom: 15),
      ));*/
      print("Location:" +
          "Latitude: ${latLon.latitude}, Longitude: ${latLon.longitude}");
      print("Address:${location ?? ""}");
    }
  }

  onClickStartShiftButton() async {
    var result;
    result = await Get.toNamed(AppRoutes.selectShiftScreen);
    if (result != null) {
      getUserWorkLogListApi();
    }
  }

  onClickStopShiftButton() async {
    userStopWorkApi();
  }

  onClickWorkLogItem(WorkLogInfo info) async {
    var arguments = {
      AppConstants.intentKey.workLogInfo: info,
      AppConstants.intentKey.date: workLogData.value.workStartDate ?? ""
    };
    var result =
        await Get.toNamed(AppRoutes.stopShiftScreen, arguments: arguments);
    print("result:" + result.toString());
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
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      CounterDetails details =
          ClockInUtils.getTotalWorkHours(workLogData.value);
      totalWorkHours.value = details.totalWorkTime;
      isOnBreak.value = details.isOnBreak;
      remainingBreakTime.value = details.remainingBreakTime;
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void onClose() {
    print("onClose");
    stopTimer();
    super.onClose();
  }
}
