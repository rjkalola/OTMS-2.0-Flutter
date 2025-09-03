import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:belcka/pages/check_in/start_shift_map/controller/start_shift_map_controller.dart';
import 'package:belcka/widgets/map_view/custom_map_view.dart';

class StartShiftMapView extends StatelessWidget {
  StartShiftMapView({super.key});

  final controller = Get.put(StartShiftMapController());

  @override
  Widget build(BuildContext context) {
    return CustomMapView(
        onMapCreated: controller.onMapCreated,
        target: controller.center);
  }
}
