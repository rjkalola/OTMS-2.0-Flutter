import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/location_info.dart';
import 'package:otm_inventory/pages/check_in/work_log_request/controller/work_log_request_repository.dart';
import 'package:otm_inventory/pages/check_in/work_log_request/model/work_log_details_info.dart';
import 'package:otm_inventory/pages/check_in/work_log_request/model/work_log_request_details_response.dart';
import 'package:otm_inventory/pages/common/listener/DialogButtonClickListener.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/AlertDialogHelper.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/location_service_new.dart';
import 'package:otm_inventory/utils/map_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

import '../../../../utils/app_constants.dart';

class WorkLogRequestController extends GetxController
    implements DialogButtonClickListener {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isLocationLoaded = true.obs,
      isDataUpdated = false.obs,
      isMainViewVisible = false.obs;
  final RxString startTime = "".obs, stopTime = "".obs;
  final RxInt status = 0.obs;
  final _api = WorkLogRequestRepository();
  final noteController = TextEditingController().obs;
  final displayNoteController = TextEditingController().obs;
  late GoogleMapController mapController;
  String? latitude, longitude, location;
  final center =
      LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude).obs;
  final locationService = LocationServiceNew();
  final workLogInfo = WorkLogDetailsInfo().obs;
  int requestLogId = 0;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

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
    // locationRequest();
    // appLifeCycle();
    LocationInfo? locationInfo = Get.find<AppStorage>().getLastLocation();
    if (locationInfo != null) {
      setLocation(double.parse(locationInfo.latitude ?? "0"),
          double.parse(locationInfo.longitude ?? "0"));
    }
  }

  Future<void> getWorkLogRequestDetails() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["request_log_id"] = requestLogId;
    _api.getWorkLogRequestDetails(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
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
          displayNoteController.value.text = workLogInfo.value.note ?? "";
          status.value = workLogInfo.value.status ?? 0;

          setLocationPin();
          locationRequest();
          appLifeCycle();
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

  Future<void> workLogRequestApproveRejectApi(int status) async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["request_worklog_id"] = workLogInfo.value.requestLogId ?? 0;
    map["status"] = status;
    map["user_id"] = workLogInfo.value.userId ?? 0;
    map["note"] = StringHelper.getText(noteController.value);

    _api.workLogRequestApproveReject(
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

  String changeFullDateToSortTime(String? date) {
    return !StringHelper.isEmptyString(date)
        ? DateUtil.changeDateFormat(
            date!, DateUtil.DD_MM_YYYY_TIME_24_SLASH2, DateUtil.HH_MM_24)
        : "";
  }

  String getCurrentTime() {
    return DateUtil.getCurrentTimeInFormat(DateUtil.HH_MM_24);
  }

  showActionDialog(String dialogType) async {
    AlertDialogHelper.showAlertDialog(
        "",
        dialogType == AppConstants.dialogIdentifier.approve
            ? 'are_you_sure_you_want_to_approve'.tr
            : 'are_you_sure_you_want_to_reject'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        true,
        this,
        dialogType);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.approve) {
      Get.back();
      workLogRequestApproveRejectApi(AppConstants.status.approved);
    } else if (dialogIdentifier == AppConstants.dialogIdentifier.reject) {
      Get.back();
      workLogRequestApproveRejectApi(AppConstants.status.rejected);
    }
  }

  void onBackPress() {
    Get.back(result: isDataUpdated.value);
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
    }

    if (stop != null) {
      final icon = await MapUtils.createIcon(
          assetPath: Drawable.bluePin, width: 24, height: 34);
      LatLng stopWorkPosition = LatLng(double.parse(stop.latitude ?? "0"),
          double.parse(stop.longitude ?? "0"));
      addMarker(stopWorkPosition, 'stopwork', icon, title: '');
    }

    if (start != null && stop != null) {
      LatLng startWorkPosition = LatLng(double.parse(start.latitude ?? "0"),
          double.parse(start.longitude ?? "0"));
      LatLng stopWorkPosition = LatLng(double.parse(stop.latitude ?? "0"),
          double.parse(stop.longitude ?? "0"));
      addPolyLone(startWorkPosition, stopWorkPosition);
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
}
