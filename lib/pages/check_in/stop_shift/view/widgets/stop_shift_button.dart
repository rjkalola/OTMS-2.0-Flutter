import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';

class StopShiftButton extends StatelessWidget {
  const StopShiftButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 16),
      child: PrimaryButton(
        buttonText: 'stop_shift'.tr,
        onPressed: () {},
        color: Colors.red,
      ),
    );
  }
}
