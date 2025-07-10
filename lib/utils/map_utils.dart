import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  static Future<BitmapDescriptor> createIcon({
    required String assetPath,
    required double width,
    required double height,
  }) async {
    Size size = Size(width, height);
    return await BitmapDescriptor.asset(
      ImageConfiguration(size: size),
      assetPath,
    );
  }

  static Polyline createPolyline({
    required String id,
    required LatLng start,
    required LatLng end,
    Color color = Colors.black,
    int width = 2,
    bool geodesic = false,
  }) {
    return Polyline(
      polylineId: PolylineId(id),
      points: [start, end],
      color: color,
      width: width,
      geodesic: geodesic, // optional: makes curve match Earth's shape
    );
  }
}
