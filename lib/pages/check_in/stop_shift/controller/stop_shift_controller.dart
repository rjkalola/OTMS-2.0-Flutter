import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_repository.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_list_response.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/controller/stop_shift_repository.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/location_service_new.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

import '../../../../utils/app_constants.dart';

class StopShiftController extends GetxController {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isLocationLoaded = true.obs,
      isDataUpdated = true.obs,
      isWorking = false.obs,
      isEdited = false.obs;
  final RxString startTime = "".obs, stopTime = "".obs;
  final _api = StopShiftRepository();
  final noteController = TextEditingController().obs;
  late GoogleMapController mapController;
  String? latitude, longitude, location;
  final center = LatLng(23.0225, 72.5714).obs;
  final locationService = LocationServiceNew();
  final workLogInfo = WorkLogInfo().obs;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      workLogInfo.value =
          arguments[AppConstants.intentKey.workLogInfo] ?? WorkLogInfo();
      setInitialTime();
    }
    locationRequest();
    appLifeCycle();
  }

  Future<void> userStopWorkApi() async {
    String deviceModelName = await AppUtils.getDeviceName();
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["user_worklog_id"] = workLogInfo.value.id ?? 0;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["location"] = location;
    map["device_type"] = AppConstants.deviceType;
    map["device_model_type"] = deviceModelName;
    ClockInRepository().userStopWork(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isDataUpdated.value = true;
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
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  Future<void> getUserWorkLogListApi() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["date"] = "";
    map["shift_id"] = 0;
    ClockInRepository().getUserWorkLogList(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          WorkLogListResponse response =
              WorkLogListResponse.fromJson(jsonDecode(responseModel.result!));
          for (var info in response.workLogInfo!) {
            if (info.id == workLogInfo.value.id) {
              workLogInfo.value = info;
              break;
            }
          }
          setInitialTime();
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
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center.value, zoom: 15),
      ));
    }
  }

  void setEdited() {
    isEdited.value = false;
  }

  setInitialTime() {
    startTime.value = changeFullDateToSortTime(workLogInfo.value.workStartTime);
    stopTime.value = changeFullDateToSortTime(workLogInfo.value.workEndTime);
    isWorking.value = StringHelper.isEmptyString(workLogInfo.value.workEndTime);
  }

  String changeFullDateToSortTime(String? date) {
    return !StringHelper.isEmptyString(date)
        ? DateUtil.changeDateFormat(
            date!, DateUtil.DD_MM_YYYY_TIME_24_SLASH2, DateUtil.HH_MM_24)
        : "";
  }

  String getCurrentTime() {
    return DateUtil.getCurrentTimeInFormat(DateUtil.HH_MM_24);
  }
}
