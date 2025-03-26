import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationServiceNew {
  bool _isChecking = false,
      _isLocationServiceDialogOpen = false,
      _isPermissionDeniedDialogOpen = false,
      _isSettingsDialogOpen = false;

  /// ✅ Check if GPS is enabled and handle permissions
  Future<void> checkLocationService() async {
    if (_isChecking) return; // Prevent duplicate calls
    _isChecking = true;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showLocationServiceDialog(); // Show GPS enable dialog
      _isChecking = false;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print("1");
      permission = await Geolocator.requestPermission();
      print("2");
      if (permission == LocationPermission.denied) {
        print("3");
        showPermissionDeniedDialog(); // Show permission denied dialog
        _isChecking = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("4");
      showSettingsDialog(); // Show open settings dialog
      _isChecking = false;
      return;
    }

    // ✅ Get location if everything is enabled
    getCurrentLocation();
    _isChecking = false;
  }

  /// ✅ Fetch Current Location
  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    print("Location: ${position.latitude}, ${position.longitude}");
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
                _isLocationServiceDialogOpen = false;
                await Geolocator.openLocationSettings();
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
                _isPermissionDeniedDialogOpen = false;
                Navigator.pop(context);
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
                _isSettingsDialogOpen = false;
                Navigator.pop(context);
                await openAppSettings(); // Open app settings
              },
              child: Text("Open Settings"),
            ),
          ],
        ),
      ),
    );
  }
}
