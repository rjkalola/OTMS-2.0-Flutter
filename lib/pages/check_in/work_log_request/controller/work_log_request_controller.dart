import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_repository.dart';
import 'package:otm_inventory/pages/check_in/work_log_request/controller/work_log_request_repository.dart';
import 'package:otm_inventory/pages/check_in/work_log_request/model/work_log_details_info.dart';
import 'package:otm_inventory/pages/check_in/work_log_request/model/work_log_request_details_response.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/location_service_new.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

import '../../../../utils/app_constants.dart';

class WorkLogRequestController extends GetxController {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isLocationLoaded = true.obs,
      isDataUpdated = false.obs;
  final RxString startTime = "".obs, stopTime = "".obs;
  final _api = WorkLogRequestRepository();
  final noteController = TextEditingController().obs;
  late GoogleMapController mapController;
  String? latitude, longitude, location;
  final center = LatLng(23.0225, 72.5714).obs;
  final locationService = LocationServiceNew();
  final workLogInfo = WorkLogDetailsInfo().obs;
  int requestLogId = 0;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      requestLogId = arguments[AppConstants.intentKey.ID] ?? 0;
      // setInitialTime();
    }
    getWorkLogRequestDetails();
    locationRequest();
    appLifeCycle();
  }

  Future<void> getWorkLogRequestDetails() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["request_log_id"] = requestLogId;
    _api.getWorkLogRequestDetails(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          WorkLogRequestDetailsResponse response =
              WorkLogRequestDetailsResponse.fromJson(
                  jsonDecode(responseModel.result!));
          workLogInfo.value = response.info!;
          startTime.value =
              changeFullDateToSortTime(workLogInfo.value.workStartTime);
          stopTime.value =
              !StringHelper.isEmptyString(workLogInfo.value.workEndTime)
                  ? changeFullDateToSortTime(workLogInfo.value.workEndTime)
                  : getCurrentTime();
          noteController.value.text = workLogInfo.value.note??"";
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

  Future<void> requestWorkLogChangeApi() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["user_worklog_id"] = workLogInfo.value.id ?? 0;
    map["start_time"] = startTime.value;
    map["end_time"] = stopTime.value;
    map["note"] = StringHelper.getText(noteController.value);

    ClockInRepository().requestWorkLogChange2(
      data: map,
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

  String changeFullDateToSortTime(String? date) {
    return !StringHelper.isEmptyString(date)
        ? DateUtil.changeDateFormat(
            date!, DateUtil.DD_MM_YYYY_TIME_24_SLASH2, DateUtil.HH_MM_24)
        : "";
  }

  String getCurrentTime() {
    return DateUtil.getCurrentTimeInFormat(DateUtil.HH_MM_24);
  }

  Color getStatusColor(int status){
    return status == 1 ? Colors.green : Colors.red;
  }

  void onBackPress() {
    Get.back(result: isDataUpdated.value);
  }
}
