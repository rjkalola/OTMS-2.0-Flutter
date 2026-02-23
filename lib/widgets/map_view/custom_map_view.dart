import 'package:belcka/utils/map_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../res/theme/theme_config.dart';

class CustomMapView extends StatefulWidget {
  CustomMapView({
    super.key,
    this.onMapCreated,
    required this.target,
    this.markers,
    this.polylines,
    this.polygons,
    this.circles,
    this.onCameraMove,
    this.onCameraIdle,
    this.initialZoom,
  });

  final MapCreatedCallback? onMapCreated;
  final Rx<LatLng> target;
  final RxSet<Marker>? markers;
  final RxSet<Polyline>? polylines;
  final RxSet<Polygon>? polygons;
  final RxSet<Circle>? circles;
  final CameraPositionCallback? onCameraMove;
  final VoidCallback? onCameraIdle;
  final double? initialZoom;

  @override
  State<CustomMapView> createState() => _CustomMapViewState();
}

class _CustomMapViewState extends State<CustomMapView> {
  bool _hideOverlay = false;

  void _handleMapCreated(GoogleMapController controller) async {
    if (widget.onMapCreated != null) {
      widget.onMapCreated!(controller);
    }

    await Future.delayed(const Duration(milliseconds: 120));

    if (mounted) {
      setState(() {
        _hideOverlay = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Stack(
        children: [
          GoogleMap(
            style: MapUtils.googleMapStyle,
            onMapCreated: _handleMapCreated,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: true,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: widget.target.value,
              zoom: widget.initialZoom ?? 15.0,
            ),
            onCameraMove: widget.onCameraMove,
            onCameraIdle: widget.onCameraIdle,
            markers: widget.markers ?? <Marker>{},
            polylines: widget.polylines ?? <Polyline>{},
            polygons: widget.polygons ?? <Polygon>{},
            circles: widget.circles ?? <Circle>{},
          ),

          // 👇 Overlay
          if (!_hideOverlay)
            IgnorePointer(
              ignoring: true, // tap pass through
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _hideOverlay ? 0 : 1,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
