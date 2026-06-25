import 'dart:convert';

import 'package:belcka/pages/project/project_info/model/geofence_info.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:belcka/pages/check_in/clock_in/controller/clock_in_repository.dart';
import 'package:belcka/pages/check_in/clock_in/controller/clock_in_utils.dart';
import 'package:belcka/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/location_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_list_response.dart';
import 'package:belcka/pages/check_in/user_stop_shift/controller/user_stop_shift_repository.dart';
import 'package:belcka/pages/check_in/stop_shift/model/work_log_details_response.dart';
import 'package:belcka/pages/check_in/clock_in/model/user_stop_work_response.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/select_time_listener.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/location_service_new.dart';
import 'package:belcka/utils/map_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';

import '../../../../utils/app_constants.dart';

class UserStopShiftController extends GetxController
    implements SelectTimeListener, DialogButtonClickListener {
  final RxBool isLoading = false.obs,
      isMainViewVisible = false.obs,
      isInternetNotAvailable = false.obs,
      isLocationLoaded = true.obs,
      isDataUpdated = false.obs,
      isWorking = false.obs,
      isEdited = false.obs,
      isShowTotalPayable = true.obs,
      showRate = false.obs;

  final RxString startTime = "".obs, stopTime = "".obs, currency = "£".obs;
  String initiallyStartTime = "", initiallyStopTime = "";
  final RxInt initialTotalWorkTime = 0.obs, updatedTotalWorkingTime = 0.obs;
  final _api = UserStopShiftRepository();
  final noteController = TextEditingController().obs;
  late GoogleMapController mapController;
  String? latitude, longitude, location;
  final center =
      LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude).obs;
  final RxSet<Marker> markers = <Marker>{}.obs;

  // final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final locationService = LocationServiceNew();
  final workLogInfo = WorkLogInfo().obs;
  List<CheckLogInfo> passedUserChecklogs = [];

  List<CheckLogInfo> get todaysActivityCheckLogs {
    final fromApi = workLogInfo.value.userChecklogs ?? [];
    final apiLogs =
        fromApi.where((log) => (log.id ?? 0) > 0).toList();
    if (apiLogs.isNotEmpty) return apiLogs;
    return passedUserChecklogs
        .where((log) => (log.id ?? 0) > 0)
        .toList();
  }

  int workLogId = 0, userId = 0;
  String date = "";
  bool isCurrentDay = true, fromNotification = false;
  VoidCallback? _pendingAfterStopWorkPenalty;
  final RxSet<Polyline> polyLines = <Polyline>{}.obs;
  final RxSet<Polygon> polygons = <Polygon>{}.obs;
  final RxSet<Circle> circles = <Circle>{}.obs;

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
      fromNotification =
          arguments[AppConstants.intentKey.fromNotification] ?? false;
      final logs = arguments[AppConstants.intentKey.userCheckLogs];
      if (logs is List<CheckLogInfo>) {
        passedUserChecklogs = logs;
      } else if (logs is List) {
        passedUserChecklogs = List<CheckLogInfo>.from(logs);
      }
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
          final response = UserStopWorkResponse.fromJson(
            jsonDecode(responseModel.result!) as Map<String, dynamic>,
          );
          _handleStopWorkSuccess(response);
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

  void _handleStopWorkSuccess(UserStopWorkResponse response) {
    if (!StringHelper.isEmptyString(response.penaltyMessage)) {
      _pendingAfterStopWorkPenalty = _continueAfterStopWorkSuccess;
      AlertDialogHelper.showAlertDialog(
        '',
        response.penaltyMessage ?? '',
        'ok'.tr,
        '',
        '',
        false,
        false,
        this,
        AppConstants.dialogIdentifier.stopWorkPenaltyDialog,
      );
      return;
    }
    if (!StringHelper.isEmptyString(response.message)) {
      AppUtils.showApiResponseMessage(response.message!);
    }
    _continueAfterStopWorkSuccess();
  }

  void _continueAfterStopWorkSuccess() {
    if (isCurrentDay) {
      getWorkLogDetailsApi();
    } else {
      Get.back(result: true);
    }
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
        AppConstants.dialogIdentifier.stopWorkPenaltyDialog) {
      Get.back();
      _pendingAfterStopWorkPenalty?.call();
      _pendingAfterStopWorkPenalty = null;
    }
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
          if (UserUtils.getLoginUserId() == response.info?.userId) {
            showRate.value = true;
          } else {
            showRate.value = Get.find<AppStorage>().isShowRate();
          }
          workLogInfo.value = response.info!;
          final apiCheckLogs = workLogInfo.value.userChecklogs
                  ?.where((log) => (log.id ?? 0) > 0)
                  .toList() ??
              [];
          if (apiCheckLogs.isEmpty && passedUserChecklogs.isNotEmpty) {
            workLogInfo.value.userChecklogs =
                List<CheckLogInfo>.from(passedUserChecklogs);
          }
          currency.value = response.currency ?? "";
          date = DateUtil.changeDateFormat(
              workLogInfo.value.workStartTime ?? "",
              DateUtil.DD_MM_YYYY_TIME_24_SLASH2,
              DateUtil.DD_MM_YYYY_SLASH);
          isCurrentDay = ClockInUtils.isCurrentDay(date);
          print("isCurrentDay:" + isCurrentDay.toString());
          setLocationPin();
          setZones();
          setInitialTime();
          if (StringHelper.isEmptyString(workLogInfo.value.workEndTime)) {
            locationRequest();
            appLifeCycle();
          }
          setTotalPayableFlag();
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
      try {
        final currentPosition = await mapController.getZoomLevel();
        mapController.moveCamera(
          CameraUpdate.newLatLngZoom(center.value, currentPosition),
        );
      } catch (_) {}
      print("Location:" + "Latitude: ${latitude}, Longitude: ${longitude}");
      print("Address:${location ?? ""}");
    }
  }

  String get formattedWorkDate {
    if (StringHelper.isEmptyString(workLogInfo.value.workStartTime)) {
      return "";
    }
    return DateUtil.changeDateFormat(
      workLogInfo.value.workStartTime!,
      DateUtil.DD_MM_YYYY_TIME_24_SLASH2,
      DateUtil.DD_MMMM_YYYY_SPACE,
    );
  }

  String get formattedWorkedTime {
    final seconds = workLogInfo.value.payableWorkSeconds ?? 0;
    return DateUtil.seconds_To_HH_MM(seconds);
  }

  void onTodaysActivityHeaderTap() {
    final arguments = {
      AppConstants.intentKey.userId: workLogInfo.value.userId ?? 0,
      AppConstants.intentKey.date: date,
    };
    moveToScreen(AppRoutes.checkInDayLogsScreen, arguments);
  }

  void onCheckLogItemTap(CheckLogInfo info) {
    final arguments = {
      AppConstants.intentKey.checkLogId: info.id ?? 0,
      AppConstants.intentKey.projectId: workLogInfo.value.projectId ?? 0,
      AppConstants.intentKey.isPriceWork: workLogInfo.value.isPricework ?? false,
    };
    moveToScreen(AppRoutes.userCheckOutScreen, arguments);
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

  void setTotalPayableFlag() {
    isShowTotalPayable.value =
        (workLogInfo.value.allWorklogsSeconds ?? 0) != 0 ||
            (workLogInfo.value.allPenaltySeconds ?? 0) != 0 ||
            (workLogInfo.value.allChecklogCount ?? 0) != 0 ||
            (workLogInfo.value.allExpenseCount ?? 0) != 0;
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
          assetPath: Drawable.bluePin, width: 24, height: 34);
      LatLng startWorkPosition = LatLng(double.parse(start.latitude ?? "0"),
          double.parse(start.longitude ?? "0"));
      addMarker(startWorkPosition, 'startwork', icon, title: '');

      if (stop == null) {
        setLocation(startWorkPosition.latitude, startWorkPosition.longitude);
      }
    }

    if (stop != null) {
      final icon = await MapUtils.createIcon(
          assetPath: Drawable.redPin, width: 24, height: 34);
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
    final updatedPolylines = Set<Polyline>.from(polyLines.value);
    updatedPolylines.add(polyline);
  }

  void setZones() {
    if (workLogInfo.value.geofences != null) {
      for (GeofenceInfo info in workLogInfo.value.geofences!) {
        if ((info.type ?? "") == AppConstants.zoneType.circle &&
            info.radius != null) {
          if (info.latitude != null && info.longitude != null) {
            print("info.latitude:" + info.latitude!.toString());
            print("info.longitude:" + info.longitude!.toString());
            LatLng latLng = LatLng(double.parse(info.latitude ?? "0.0"),
                double.parse(info.longitude ?? "0.0"));
            Color color = !StringHelper.isEmptyString(info.color)
                ? AppUtils.getColor(info.color ?? "")
                : Colors.blue;
            final circle = AppUtils.getCircle(
                id: (info.id ?? 0).toString(),
                latLng: latLng,
                radius: info.radius ?? 0,
                color: color);
            final updatedCircles = Set<Circle>.from(circles);
            updatedCircles.add(circle);
            circles.value = updatedCircles;
          }
        } else if ((info.type ?? "") == AppConstants.zoneType.polygon &&
            info.coordinates != null) {
          List<LatLng> listLatLng = [];
          for (GeofenceCoordinates coordinates in info.coordinates!) {
            LatLng latLng = LatLng(coordinates.lat ?? 0, coordinates.lng ?? 0);
            listLatLng.add(latLng);
          }
          Color color = !StringHelper.isEmptyString(info.color)
              ? AppUtils.getColor(info.color ?? "")
              : Colors.blue;
          final polygon = AppUtils.getPolygon(
              id: (info.id ?? 0).toString(),
              listLatLng: listLatLng,
              color: color);
          final updatedPolygon = Set<Polygon>.from(polygons);
          updatedPolygon.add(polygon);
          polygons.value = updatedPolygon;
        } else if ((info.type ?? "") == AppConstants.zoneType.polyline &&
            info.coordinates != null) {
          List<LatLng> listLatLng = [];
          for (GeofenceCoordinates coordinates in info.coordinates!) {
            LatLng latLng = LatLng(coordinates.lat ?? 0, coordinates.lng ?? 0);
            listLatLng.add(latLng);
          }
          Color color = !StringHelper.isEmptyString(info.color ?? "")
              ? AppUtils.getColor(info.color ?? "#000000")
              : Colors.blue;
          final polyline = AppUtils.getPolyline(
              id: (info.id ?? 0).toString(),
              listLatLng: listLatLng,
              color: color);
          final updatedPolyline = Set<Polyline>.from(polyLines);
          updatedPolyline.add(polyline);
          polyLines.value = updatedPolyline;
        }
      }
    }
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated.value = true;
      getWorkLogDetailsApi();
    }
  }

  void onBackPress() {
    if (fromNotification) {
      Get.offAllNamed(AppRoutes.dashboardScreen);
    } else {
      Get.back(result: isDataUpdated.value);
    }
  }
}
