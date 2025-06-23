import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/start_shift_box.dart';

class StartStopBoxRow extends StatelessWidget {
  const StartStopBoxRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
      child: Row(
        children: [
          StartShiftBox(
              title: 'start_shift'.tr,
              time: "08:00",
              address: "650, High road, 650, High road,"),
          SizedBox(
            width: 14,
          ),
          StartShiftBox(
              title: 'stop_shift'.tr,
              time: "17:00",
              address: "650, High road, 650, High road,"),
        ],
      ),
    );
  }
}
