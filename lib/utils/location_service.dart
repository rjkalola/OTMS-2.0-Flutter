import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    bool _isDialogOpen = false;
    bool _isChecking = false;

    print("isLocationServiceEnabled Start");

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    print("serviceEnabled:" + serviceEnabled.toString());

    if (!serviceEnabled) return null;

    if (_isChecking) return null;
    _isChecking = true;

    permission = await Geolocator.checkPermission();
    print("Permission Start");
    if (permission == LocationPermission.denied) {
      print("LocationPermission.denied");
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) {
      print("LocationPermission.deniedForever");
      if (!_isDialogOpen) {
        _isDialogOpen = true;
        showLocationDialog();
      }
      return null;
    }

    await Future.delayed(Duration(seconds: 1));
    _isChecking = false;
    print("Permission End");

    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high, // Set accuracy here
      ),
    );
  }

  static Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placeMarks.isNotEmpty) {
        Placemark place = placeMarks.first;
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
      // return "No address found";
      return "";
    } catch (e, stack) {
      print("Error: $e");
      print("Stack: $stack");
      return "";
    }
  }

  static void showLocationDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Permission Required"),
        content: Text(
            "Location access is permanently denied. Please enable it from settings."),
        actions: [
          // TextButton(
          //   onPressed: () => Navigator.pop(context),
          //   child: Text("Cancel"),
          // ),
          TextButton(
            onPressed: () async {
              // Navigator.pop(context);
              Get.back();
              await openAppSettings(); // Open device settings
            },
            child: Text("Open Settings"),
          ),
        ],
      ),
    );
  }
}
