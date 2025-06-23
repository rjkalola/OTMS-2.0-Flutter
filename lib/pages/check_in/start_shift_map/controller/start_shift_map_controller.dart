import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otm_inventory/pages/check_in/dialogs/select_shift_dialog.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/shifts/create_shift/model/shift_info.dart';
import 'package:otm_inventory/pages/shifts/shift_list/controller/shift_list_repository.dart';
import 'package:otm_inventory/pages/shifts/shift_list/model/shift_list_response.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/location_service_new.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class StartShiftMapController extends GetxController
    implements SelectItemListener {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isLocationLoaded = true.obs;
  final shiftList = <ShiftInfo>[].obs;
  late GoogleMapController mapController;
  final center = LatLng(23.0225, 72.5714).obs;
  Position? latLon = null;
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
          shiftList.value = response.info ?? [];
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
    print("locationLoaded:" + isLocationLoaded.toString());
    if (isLocationLoaded) {
      fetchLocationAndAddress();
    }
  }

  Future<void> fetchLocationAndAddress() async {
    print("fetchLocationAndAddress");
    latLon = await LocationServiceNew.getCurrentLocation();
    if (latLon != null) {
      isLocationLoaded.value = true;
      String latitude = latLon!.latitude.toString();
      String longitude = latLon!.longitude.toString();
      String location = await LocationServiceNew.getAddressFromCoordinates(
          latLon!.latitude, latLon!.longitude);
      center.value = LatLng(latLon!.latitude, latLon!.longitude);
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center.value, zoom: 15),
      ));
      print("Location:" +
          "Latitude: ${latLon!.latitude}, Longitude: ${latLon!.longitude}");
      print(location ?? "");
      AppUtils.showToastMessage("Address:${location ?? ""}");
    } else {
      print("Location:" + "Location permission denied or services disabled");
      print("Address:" + "Could not retrieve address");
      AppUtils.showToastMessage("Could not retrieve address");
    }
  }

  void showSelectShiftDialog() {
    Get.bottomSheet(
        SelectShiftDialog(
          dialogType: AppConstants.dialogIdentifier.selectShift,
          list: DataUtils.getPhoneExtensionList(),
          listener: this,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectShift) {
      Get.toNamed(AppRoutes.clockInScreen);
    }
  }
}
