import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otm_inventory/pages/check_in/select_shift/controller/select_shift_repository.dart';
import 'package:otm_inventory/pages/check_in/select_shift/model/start_work_response.dart';
import 'package:otm_inventory/pages/shifts/shift_list/controller/shift_list_repository.dart';
import 'package:otm_inventory/pages/shifts/shift_list/model/shift_list_response.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/location_service_new.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

import '../../../../web_services/response/response_model.dart';

class SelectShiftController extends GetxController {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isLocationLoaded = true.obs,
      isClearVisible = false.obs;
  final _api = SelectShiftRepository();
  final noteController = TextEditingController().obs;
  late GoogleMapController mapController;
  final center = LatLng(23.0225, 72.5714).obs;
  final locationService = LocationServiceNew();
  String latitude = "", longitude = "", location = "";
  final searchController = TextEditingController().obs;
  final shiftList = <ModuleInfo>[].obs;
  List<ModuleInfo> tempList = [];
  bool fromStartShiftScreen = false;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      fromStartShiftScreen =
          arguments[AppConstants.intentKey.fromStartShiftScreen] ?? "";
    }
    locationRequest();
    appLifeCycle();
    getShiftListApi();
  }

  void getShiftListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    ShiftListRepository().getShiftList(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          ShiftListResponse response =
              ShiftListResponse.fromJson(jsonDecode(responseModel.result!));
          tempList.clear();
          for (var data in response.info!) {
            if (data.status ?? false) {
              tempList.add(ModuleInfo(
                  id: data.id ?? 0,
                  name: data.name ?? "",
                  randomColor: getRandomColor()));
            }
          }
          shiftList.value = tempList;
          shiftList.refresh();
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

  Future<void> userStartWorkApi(int shiftId) async {
    String deviceModelName = await AppUtils.getDeviceName();
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["shift_id"] = shiftId;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["location"] = location;
    map["device_type"] = AppConstants.deviceType;
    map["device_model_type"] = deviceModelName;
    _api.userStartWork(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          StartWorkResponse response =
              StartWorkResponse.fromJson(jsonDecode(responseModel.result!));
          if (fromStartShiftScreen) {
            Get.offNamed(AppRoutes.clockInScreen);
          } else {
            Get.back(result: true);
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

  Future<void> searchItem(String value) async {
    print(value);
    List<ModuleInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) => (!StringHelper.isEmptyString(element.name) &&
              element.name!.toLowerCase().contains(value.toLowerCase())))
          .toList();
    }
    shiftList.value = results;
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
    print("locationLoaded:" + isLocationLoaded.toString());
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
      print("Location:" +
          "Latitude: ${latLon.latitude}, Longitude: ${latLon.longitude}");
    }
  }

  String getRandomColor() {
    String color = "#CB4646DD";
    final random = Random();
    int randomNumber = random.nextInt(DataUtils.listColors.length - 1);
    color = DataUtils.listColors[randomNumber];
    return color;
  }
}
