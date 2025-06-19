import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otm_inventory/pages/check_in/dialogs/select_shift_dialog.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/location_service_new.dart';

class StartShiftMapController extends GetxController
    implements SelectItemListener {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isLocationLoaded = true.obs;
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
