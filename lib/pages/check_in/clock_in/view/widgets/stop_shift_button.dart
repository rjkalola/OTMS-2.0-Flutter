import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';

class StopShiftButton extends StatelessWidget {
  const StopShiftButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
        width: double.infinity,
        child: PrimaryButton(
          buttonText: 'stop_shift'.tr,
          onPressed: () {},
          color: Color(0xffFF6464),
          fontWeight: FontWeight.w500,
          fontSize: 16,
          borderRadius: 15,
        ));
  }
}
