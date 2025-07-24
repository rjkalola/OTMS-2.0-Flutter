import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_repository.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_utils.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/location_info.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_list_response.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/controller/stop_shift_repository.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/model/work_log_details_response.dart';
import 'package:otm_inventory/pages/common/listener/select_time_listener.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/location_service_new.dart';
import 'package:otm_inventory/utils/map_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/utils/user_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

import '../../../../utils/app_constants.dart';

class StopShiftController extends GetxController implements SelectTimeListener {
  final RxBool isLoading = false.obs,
      isMainViewVisible = false.obs,
      isInternetNotAvailable = false.obs,
      isLocationLoaded = true.obs,
      isDataUpdated = false.obs,
      isWorking = false.obs,
      isEdited = false.obs;

  final RxString startTime = "".obs, stopTime = "".obs;
  String initiallyStartTime = "", initiallyStopTime = "";
  final RxInt initialTotalWorkTime = 0.obs, updatedTotalWorkingTime = 0.obs;
  final _api = StopShiftRepository();
  final noteController = TextEditingController().obs;
  late GoogleMapController mapController;
  String? latitude, longitude, location;
  final center =
      LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude).obs;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final locationService = LocationServiceNew();
  final workLogInfo = WorkLogInfo().obs;
  int workLogId = 0, userId = 0;
  String date = "";
  bool isCurrentDay = true;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      workLogId = arguments[AppConstants.intentKey.workLogId] ?? 0;
      userId = arguments[AppConstants.intentKey.userId] ?? 0;
      print("userId:" + userId.toString());
    }
    LocationInfo? locationInfo = Get.find<AppStorage>().getLastLocation();
    if (locationInfo != null) {
      setLocation(double.parse(locationInfo.latitude ?? "0"),
          double.parse(locationInfo.longitude ?? "0"));
    }

    getWorkLogDetailsApi();
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
          if (isCurrentDay) {
            // getUserWorkLogListApi();
            getWorkLogDetailsApi();
          } else {
            Get.back(result: true);
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
    if (UserUtils.isAdmin()) {
      map["user_id"] = userId;
    }

    _api.requestWorkLogChange(
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

  Future<void> getWorkLogDetailsApi() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["worklog_id"] = workLogId;

    _api.getWorkLogDetails(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          WorkLogDetailsResponse response = WorkLogDetailsResponse.fromJson(
              jsonDecode(responseModel.result!));
          workLogInfo.value = response.info!;
          date = DateUtil.changeDateFormat(
              workLogInfo.value.workStartTime ?? "",
              DateUtil.DD_MM_YYYY_TIME_24_SLASH2,
              DateUtil.DD_MM_YYYY_SLASH);
          isCurrentDay = ClockInUtils.isCurrentDay(date);
          print("isCurrentDay:" + isCurrentDay.toString());
          setLocationPin();
          setInitialTime();
          if (StringHelper.isEmptyString(workLogInfo.value.workEndTime)) {
            locationRequest();
            appLifeCycle();
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
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center.value, zoom: 15),
      ));
      print("Location:" + "Latitude: ${latitude}, Longitude: ${longitude}");
      print("Address:${location ?? ""}");
    }
  }

  void setEdited() {
    isEdited.value = false;
  }

  setInitialTime() {
    startTime.value = changeFullDateToSortTime(workLogInfo.value.workStartTime);
    stopTime.value = !StringHelper.isEmptyString(workLogInfo.value.workEndTime)
        ? changeFullDateToSortTime(workLogInfo.value.workEndTime)
        : getCurrentTime();
    initiallyStartTime = startTime.value;
    initiallyStopTime = stopTime.value;
    print("initiallyStartTime:" + initiallyStartTime);
    print("initiallyStopTime:" + initiallyStopTime);
    /*initialTotalWorkTime.value =
        !StringHelper.isEmptyString(workLogInfo.value.workEndTime)
            ? workLogInfo.value.totalWorkSeconds ?? 0
            : getTotalTimeDifference(startTime.value, stopTime.value);*/
    initialTotalWorkTime.value = workLogInfo.value.payableWorkSeconds ?? 0;
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

  int getTotalTimeDifference(String startTime, String endTime) {
    print("startTime:" + startTime);
    print("endTime:" + endTime);
    DateTime? startDate = DateUtil.stringToDate(startTime, DateUtil.HH_MM_24);
    DateTime? endDate = DateUtil.stringToDate(endTime, DateUtil.HH_MM_24);
    return DateUtil.dateDifferenceInSeconds(date1: startDate, date2: endDate);
  }

  void showTimePickerDialog(String dialogIdentifier, DateTime? time) {
    DateUtil.showTimePickerDialog(
        initialTime: time,
        dialogIdentifier: dialogIdentifier,
        selectTimeListener: this);
  }

  @override
  void onSelectTime(DateTime time, String dialogIdentifier) {
    if (dialogIdentifier ==
        AppConstants.dialogIdentifier.selectShiftStartTime) {
      startTime.value = DateUtil.timeToString(time, DateUtil.HH_MM_24);
    } else if (dialogIdentifier ==
        AppConstants.dialogIdentifier.selectShiftEndTime) {
      stopTime.value = DateUtil.timeToString(time, DateUtil.HH_MM_24);
    }
    updatedTotalWorkingTime.value =
        getTotalTimeDifference(startTime.value ?? "", stopTime.value ?? "");

    /*  isEdited.value =
        (updatedTotalWorkingTime.value != initialTotalWorkTime.value) ||
            ((initiallyStartTime != startTime.value) ||
                (initiallyStopTime != stopTime.value));*/
    isEdited.value = (initiallyStartTime != startTime.value) ||
        (initiallyStopTime != stopTime.value);
    workLogInfo.refresh();
  }

  Future<void> setLocationPin() async {
    LocationInfo? start = workLogInfo.value.startWorkLocation;
    LocationInfo? stop = workLogInfo.value.stopWorkLocation;

    if (start != null) {
      final icon = await MapUtils.createIcon(
          assetPath: Drawable.redPin, width: 24, height: 34);
      LatLng startWorkPosition = LatLng(double.parse(start.latitude ?? "0"),
          double.parse(start.longitude ?? "0"));
      addMarker(startWorkPosition, 'startwork', icon, title: '');

      if (stop == null) {
        setLocation(startWorkPosition.latitude, startWorkPosition.longitude);
      }
    }

    if (stop != null) {
      final icon = await MapUtils.createIcon(
          assetPath: Drawable.bluePin, width: 24, height: 34);
      LatLng stopWorkPosition = LatLng(double.parse(stop.latitude ?? "0"),
          double.parse(stop.longitude ?? "0"));
      addMarker(stopWorkPosition, 'stopwork', icon, title: '');
      setLocation(stopWorkPosition.latitude, stopWorkPosition.longitude);
    }

    if (start != null && stop != null) {
      LatLng startWorkPosition = LatLng(double.parse(start.latitude ?? "0"),
          double.parse(start.longitude ?? "0"));
      LatLng stopWorkPosition = LatLng(double.parse(stop.latitude ?? "0"),
          double.parse(stop.longitude ?? "0"));
      addPolyLone(startWorkPosition, stopWorkPosition);
      setLocation(stopWorkPosition.latitude, stopWorkPosition.longitude);
    }
  }

  void addMarker(LatLng position, String id, BitmapDescriptor icon,
      {String? title}) {
    final newMarker = Marker(
      markerId: MarkerId(id),
      position: position,
      icon: icon,
      infoWindow: InfoWindow(title: title ?? 'Marker $id'),
    );

    // Important: copy the existing markers to trigger reactive update
    final updatedMarkers = Set<Marker>.from(markers);
    updatedMarkers.add(newMarker);
    markers.value = updatedMarkers;
  }

  void addPolyLone(LatLng start, LatLng stop) {
    final polyline = MapUtils.createPolyline(
      id: 'route_1',
      start: start,
      end: stop,
    );
    final updatedPolylines = Set<Polyline>.from(polylines.value);
    updatedPolylines.add(polyline);
    polylines.value = updatedPolylines;
  }

  void onBackPress() {
    Get.back(result: isDataUpdated.value);
  }
}
