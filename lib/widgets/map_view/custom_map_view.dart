import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMapView extends StatelessWidget {
  CustomMapView({super.key, this.onMapCreated, required this.target});

  final MapCreatedCallback? onMapCreated;
  final Rx<LatLng> target;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GoogleMap(
        onMapCreated: onMapCreated,
        rotateGesturesEnabled: false,
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
          target: target.value,
          zoom: 11.0,
        ),
      ),
    );
  }
}
