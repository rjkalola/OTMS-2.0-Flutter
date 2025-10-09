import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMapView extends StatelessWidget {
  CustomMapView(
      {super.key,
      this.onMapCreated,
      required this.target,
      this.markers,
      this.polylines,
      this.circles,
      this.onCameraMove,
      this.initialZoom});

  final MapCreatedCallback? onMapCreated;
  final Rx<LatLng> target;
  final RxSet<Marker>? markers;
  final RxSet<Polyline>? polylines;
  final RxSet<Circle>? circles;
  final CameraPositionCallback? onCameraMove;
  final double? initialZoom;

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
          zoom: initialZoom ?? 15.0,
        ),
        onCameraMove: onCameraMove,
        markers: markers ?? <Marker>{},
        polylines: polylines ?? <Polyline>{},
        circles: circles ?? <Circle>{},
      ),
    );
  }
}
