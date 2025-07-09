import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationServiceNew {
  bool _isChecking = false,
      _isLocationServiceDialogOpen = false,
      _isPermissionDeniedDialogOpen = false,
      _isSettingsDialogOpen = false;

  /// ✅ Check if GPS is enabled and handle permissions
  Future<bool> checkLocationService() async {
    if (_isChecking) return false; // Prevent duplicate calls
    _isChecking = true;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print("serviceEnabled:" + serviceEnabled.toString());
    if (!serviceEnabled) {
      showLocationServiceDialog(); // Show GPS enable dialog
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showPermissionDeniedDialog(); // Show permission denied dialog
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSettingsDialog(); // Show open settings dialog
      print("LocationPermission.deniedForever");
      return false;
    }

    _isChecking = false;
    return true;
    // ✅ Get location if everything is enabled
    // getCurrentLocation();
  }

  /// ✅ Fetch Current Location
  static Future<Position?> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    Get.find<AppStorage>().setLastLocation(position);
    print("Location: ${position.latitude}, ${position.longitude}");
    return position;
  }

  static Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placeMarks.isNotEmpty) {
        Placemark place = placeMarks.first;
        return '${place.street}, ${place.subLocality}, '
            '${place.locality}, ${place.administrativeArea}, '
            '${place.postalCode}, ${place.country}';
        // return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
      // return "No address found";
      return "";
    } catch (e, stack) {
      print("Error: $e");
      print("Stack: $stack");
      return "";
    }
  }

  /// ❌ Show dialog if GPS is disabled
  void showLocationServiceDialog() {
    if (_isLocationServiceDialogOpen) return; // Prevent multiple dialogs
    _isLocationServiceDialogOpen = true;

    showDialog(
      context: Get.context!,
      barrierDismissible: false, // Prevent dismissing
      builder: (context) => WillPopScope(
        onWillPop: () async => false, // Disable back button
        child: AlertDialog(
          title: Text("Enable Location Services"),
          content: Text("GPS is disabled. Please enable it in settings."),
          actions: [
            TextButton(
              onPressed: () async {
                _isChecking = false;
                _isLocationServiceDialogOpen = false;
                await Geolocator.openLocationSettings();
                Get.back();
              },
              child: Text("Open Settings"),
            ),
          ],
        ),
      ),
    );
  }

  /// ❌ Show dialog if permission is denied
  void showPermissionDeniedDialog() {
    if (_isPermissionDeniedDialogOpen) return; // Prevent multiple dialogs
    _isPermissionDeniedDialogOpen = true;
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text("Permission Required"),
          content: Text("Location permission is needed for this feature."),
          actions: [
            TextButton(
              onPressed: () => () {
                _isChecking = false;
                _isPermissionDeniedDialogOpen = false;
                Get.back();
              },
              child: Text("OK"),
            ),
          ],
        ),
      ),
    );
  }

  /// ❌ Show dialog if permission is permanently denied
  void showSettingsDialog() {
    if (_isSettingsDialogOpen) return; // Prevent multiple dialogs
    _isSettingsDialogOpen = true;
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text("Permission Required"),
          content: Text(
              "Location permission is permanently denied. Enable it in settings."),
          actions: [
            TextButton(
              onPressed: () async {
                _isChecking = false;
                _isSettingsDialogOpen = false;
                await openAppSettings(); // Open app settings
                Get.back();
              },
              child: Text("Open Settings"),
            ),
          ],
        ),
      ),
    );
  }
}
