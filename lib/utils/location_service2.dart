import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationServiceHandler extends StatefulWidget {
  @override
  _LocationServiceHandlerState createState() => _LocationServiceHandlerState();
}

class _LocationServiceHandlerState extends State<LocationServiceHandler> {
  bool _isChecking = false; // Prevent multiple calls

  @override
  void initState() {
    super.initState();
    AppLifecycleListener(
      onResume: () {
        checkLocationService(); // Check service on resume
      },
    );
    checkLocationService(); // Initial check when screen loads
  }

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
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showPermissionDeniedDialog(); // Show permission denied dialog
        _isChecking = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
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
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing
      builder: (context) => WillPopScope(
        onWillPop: () async => false, // Disable back button
        child: AlertDialog(
          title: Text("Enable Location Services"),
          content: Text("GPS is disabled. Please enable it in settings."),
          actions: [
            TextButton(
              onPressed: () async {
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text("Permission Required"),
          content: Text("Location permission is needed for this feature."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      ),
    );
  }

  /// ❌ Show dialog if permission is permanently denied
  void showSettingsDialog() {
    showDialog(
      context: context,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Location Service Example")),
      body: Center(
        child: ElevatedButton(
          onPressed: checkLocationService,
          child: Text("Check Location Service"),
        ),
      ),
    );
  }
}
