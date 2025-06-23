import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_repository.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/new_time_sheet_resources_response.dart';
import 'package:otm_inventory/pages/dashboard/models/dashboard_response.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/location_service_new.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class ClockInController extends GetxController {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isLocationLoaded = false.obs;
  final _api = ClockInRepository();
  late GoogleMapController mapController;
  final center = LatLng(37.42796133580664, -122.085749655962).obs;
  final dashboardResponse = DashboardResponse().obs;
  final resourcesData = NewTimeSheetResourcesResponse().obs;
  String? latitude, longitude, location, shiftId;
  final workLogId = 0.obs;
  final locationService = LocationServiceNew();

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
    workLogId.value = Get.find<AppStorage>().getWorkLogId();
    shiftId = Get.find<AppStorage>().getShiftId();
    locationRequest();
    appLifeCycle();
  }

  Future<void> userStopWorkApi() async {
    String deviceModelName = await AppUtils.getDeviceName();
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["user_worklog_id"] = workLogId.value;
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
          Get.find<AppStorage>().setWorkLogId(0);
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
    print("fetchLocationAndAddress");
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
      print("Location:" +
          "Latitude: ${latLon.latitude}, Longitude: ${latLon.longitude}");
      print("Address:${location ?? ""}");
    } else {
      print("Location:" + "Location permission denied or services disabled");
      print("Address:" + "Could not retrieve address");
    }
  }

  onClickStopShiftButton() async {
    userStopWorkApi();
    // var result;
    // result = await Get.toNamed(AppRoutes.stopShiftScreen);
    // if (result != null) {}
  }
}
