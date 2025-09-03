import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/clock_in/controller/clock_in_controller.dart';

class MapView extends StatelessWidget {
  MapView({super.key});

  final controller = Get.put(ClockInController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Container(
            color: Colors.black12,
            width: double.infinity,
            height: 400,
            child: GoogleMap(
              onMapCreated: controller.onMapCreated,
              rotateGesturesEnabled: false,
              mapToolbarEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: controller.center.value,
                zoom: 11.0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.all(10),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Color(0x40000000),
                shape: BoxShape.circle,
              ),
              child: Icon(
                size: 24,
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
