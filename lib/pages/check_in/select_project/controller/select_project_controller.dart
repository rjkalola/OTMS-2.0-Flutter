import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:belcka/pages/check_in/clock_in/model/location_info.dart';
import 'package:belcka/pages/check_in/select_project/controller/select_project_repository.dart';
import 'package:belcka/pages/project/project_info/model/project_list_response.dart';
import 'package:belcka/pages/project/project_list/controller/project_list_repository.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/location_service_new.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';

import '../../../../web_services/response/response_model.dart';

class SelectProjectController extends GetxController {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isLocationLoaded = true.obs,
      isClearVisible = false.obs;
  final _api = SelectProjectRepository();
  final noteController = TextEditingController().obs;

  // late GoogleMapController mapController;
  final Completer<GoogleMapController> mapController = Completer();
  final center =
      LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude).obs;
  final locationService = LocationServiceNew();
  String latitude = "", longitude = "", location = "";
  final searchController = TextEditingController().obs;
  final projectsList = <ModuleInfo>[].obs;
  List<ModuleInfo> tempList = [];
  bool fromStartShiftScreen = false, switchProject = false;
  int workLogId = 0;

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
    // mapController = controller;
  }

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      fromStartShiftScreen =
          arguments[AppConstants.intentKey.fromStartShiftScreen] ?? false;
      switchProject = arguments[AppConstants.intentKey.switchProject] ?? false;
      workLogId = arguments[AppConstants.intentKey.workLogId] ?? 0;
    }
    LocationInfo? locationInfo = Get.find<AppStorage>().getLastLocation();
    if (locationInfo != null) {
      setLocation(double.parse(locationInfo.latitude ?? "0"),
          double.parse(locationInfo.longitude ?? "0"));
    }
    locationRequest();
    appLifeCycle();
    getProjectListApi();
  }

  void getProjectListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    // map["company_id"] = 0;

    ProjectListRepository().getProjectList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          ProjectListResponse response =
              ProjectListResponse.fromJson(jsonDecode(responseModel.result!));
          tempList.clear();
          for (var data in response.info!) {
            tempList.add(ModuleInfo(
                id: data.id ?? 0,
                name: data.name ?? "",
                randomColor: getRandomColor()));
          }
          projectsList.value = tempList;
          projectsList.refresh();
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
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
    projectsList.value = results;
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
      setLocation(latLon.latitude, latLon.longitude);
    }
  }

  Future<void> setLocation(double? lat, double? lon) async {
    if (lat != null && lon != null) {
      latitude = lat.toString();
      longitude = lon.toString();
      center.value = LatLng(lat, lon);
      location = await LocationServiceNew.getAddressFromCoordinates(lat, lon);
      final controller = await mapController.future;
      // controller.animateCamera(CameraUpdate.newCameraPosition(
      //   CameraPosition(target: center.value, zoom: 15),
      // ));
      final currentPosition = await controller.getZoomLevel();
      print("currentPosition:" + currentPosition.toString());
      controller.moveCamera(
        CameraUpdate.newLatLngZoom(
          center.value, // target
          currentPosition, // zoom level
        ),
      );
      print("Location:" + "Latitude: ${latitude}, Longitude: ${longitude}");
      print("Address:${location ?? ""}");
    }
  }

  String getRandomColor() {
    String color = "#CB4646DD";
    final random = Random();
    int randomNumber = random.nextInt(DataUtils.listColors.length - 1);
    color = DataUtils.listColors[randomNumber];
    return color;
  }

  Future<void> moveToScreen(int? projectId) async {
    print("projectId:" + projectId.toString());
    var arguments = {
      AppConstants.intentKey.fromStartShiftScreen: fromStartShiftScreen,
      AppConstants.intentKey.switchProject: switchProject,
      AppConstants.intentKey.workLogId: workLogId,
      AppConstants.intentKey.ID: projectId ?? 0,
    };
    if (fromStartShiftScreen) {
      Get.offNamed(AppRoutes.selectShiftScreen, arguments: arguments);
    } else {
      var result =
          await Get.toNamed(AppRoutes.selectShiftScreen, arguments: arguments);
      if (result != null && true) {
        Get.back(result: true);
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    Get.delete<SelectProjectController>();
  }
}
