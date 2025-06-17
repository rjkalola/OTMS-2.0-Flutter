import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otm_inventory/utils/location_service_new.dart';

class StartShiftMapController extends GetxController {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs;
  late GoogleMapController mapController;
  final center = LatLng(23.0225, 72.5714).obs;
  bool locationLoaded = false;
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
        if (!locationLoaded) locationRequest();
      },
    );
  }

  Future<void> locationRequest() async {
    locationLoaded = await locationService.checkLocationService();
    print("locationLoaded:"+locationLoaded.toString());
    if (locationLoaded) {
      fetchLocationAndAddress();
    }
  }

  Future<void> fetchLocationAndAddress() async {
    print("fetchLocationAndAddress");
    latLon = await LocationServiceNew.getCurrentLocation();
    if (latLon != null) {
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
      print("Address:${location ?? ""}");
    } else {
      print("Location:" + "Location permission denied or services disabled");
      print("Address:" + "Could not retrieve address");
    }
  }
}
