import 'package:belcka/pages/project/add_address/controller/add_address_controller.dart';
import 'package:belcka/widgets/slider/custom_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressCircleSizeProgress extends StatelessWidget {
  AddressCircleSizeProgress({super.key});

  final controller = Get.put(AddAddressController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      width: double.infinity,
      child: CustomSlider(
        progress: controller.circleRadius.toInt().obs,
        onChanged: (newValue) {
          controller.circleRadius.value = newValue.roundToDouble().toDouble();
        },
      ),
    );
  }
}
