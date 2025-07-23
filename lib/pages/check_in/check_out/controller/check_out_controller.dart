import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otm_inventory/pages/check_in/check_out/controller/check_out_repository.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/location_info.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/controller/stop_shift_repository.dart';
import 'package:otm_inventory/pages/common/model/file_info.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/location_service_new.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../../../utils/app_constants.dart';

class CheckOutController extends GetxController {
  final RxBool isLoading = false.obs,
      isMainViewVisible = true.obs,
      isInternetNotAvailable = false.obs,
      isLocationLoaded = true.obs;

  final _api = CheckOutRepository();
  final addressController = TextEditingController().obs;
  final tradeController = TextEditingController().obs;
  final typeOfWorkController = TextEditingController().obs;
  final noteController = TextEditingController().obs;
  late GoogleMapController mapController;
  String? latitude, longitude, location;
  final center =
      LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude).obs;
  final locationService = LocationServiceNew();
  final workLogInfo = WorkLogInfo().obs;
  int workLogId = 0, userId = 0;
  String date = "";
  bool isCurrentDay = true;
  final listBeforePhotos = <FilesInfo>[].obs;

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
    }
    LocationInfo? locationInfo = Get.find<AppStorage>().getLastLocation();
    if (locationInfo != null) {
      setLocation(double.parse(locationInfo.latitude ?? "0"),
          double.parse(locationInfo.longitude ?? "0"));
    }
    locationRequest();
    appLifeCycle();
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

  setInitialTime() {}

  String changeFullDateToSortTime(String? date) {
    return !StringHelper.isEmptyString(date)
        ? DateUtil.changeDateFormat(
            date!, DateUtil.DD_MM_YYYY_TIME_24_SLASH2, DateUtil.HH_MM_24)
        : "";
  }

  String getCurrentTime() {
    return DateUtil.getCurrentTimeInFormat(DateUtil.HH_MM_24);
  }

  Future<void> onSelectPhotos(
      String photosType, List<FilesInfo> listPhotos) async {
    var result;
    var arguments = {
      AppConstants.intentKey.photosType: photosType,
      AppConstants.intentKey.photosList: listPhotos,
    };
    // result = await Get.toNamed(AppRoutes.selectBeforeAfterPhotosScreen,
    //     arguments: arguments);

    result = await Navigator.of(Get.context!).pushNamed(
        AppRoutes.selectBeforeAfterPhotosScreen,
        arguments: arguments);

    if (result != null) {
      var arguments = result;
      if (arguments != null) {
        photosType = arguments[AppConstants.intentKey.photosType] ?? "";
        if (photosType == AppConstants.type.beforePhotos) {
          listBeforePhotos.clear();
          listBeforePhotos
              .addAll(arguments[AppConstants.intentKey.photosList] ?? []);
        }
      }
    }
  }
}
