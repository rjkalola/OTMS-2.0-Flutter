import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otm_inventory/pages/check_in/start_shift_map/controller/start_shift_map_controller.dart';

class StartShiftMapView extends StatelessWidget {
  StartShiftMapView({super.key});

  final controller = Get.put(StartShiftMapController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GoogleMap(
        onMapCreated: controller.onMapCreated,
        rotateGesturesEnabled: false,
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
          target: controller.center.value,
          zoom: 11.0,
        ),
      ),
    );
  }
}
