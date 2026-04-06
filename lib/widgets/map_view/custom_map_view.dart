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
    /// When set, increments whenever map overlays are rebuilt with new data so
    /// [Obx] updates even if marker/circle/polygon *counts* are unchanged (e.g. zone edit).
    this.overlayRevision,
    this.onCameraMove,
    this.onCameraIdle,
    this.onTap,
    this.initialZoom,
    this.mapType,
  });

  final MapCreatedCallback? onMapCreated;
  final Rx<LatLng> target;
  final RxSet<Marker>? markers;
  final RxSet<Polyline>? polylines;
  final RxSet<Polygon>? polygons;
  final RxSet<Circle>? circles;
  final Rx<int>? overlayRevision;
  final CameraPositionCallback? onCameraMove;
  final VoidCallback? onCameraIdle;
  final ArgumentCallback<LatLng>? onTap;
  final double? initialZoom;
  final Rx<MapType>? mapType;

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
      () {
        final _ = (
          widget.target.value,
          widget.mapType?.value,
          widget.markers?.length,
          widget.polylines?.length,
          widget.polygons?.length,
          widget.circles?.length,
          widget.overlayRevision?.value,
        );
        return Stack(
          children: [
            GoogleMap(
              style: MapUtils.googleMapStyle,
              onMapCreated: _handleMapCreated,
              mapType: widget.mapType?.value ?? MapType.normal,
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
              onTap: widget.onTap,
              markers: widget.markers != null
                  ? Set<Marker>.from(widget.markers!)
                  : <Marker>{},
              polylines: widget.polylines != null
                  ? Set<Polyline>.from(widget.polylines!)
                  : <Polyline>{},
              polygons: widget.polygons != null
                  ? Set<Polygon>.from(widget.polygons!)
                  : <Polygon>{},
              circles: widget.circles != null
                  ? Set<Circle>.from(widget.circles!)
                  : <Circle>{},
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
        );
      },
    );
  }
}
