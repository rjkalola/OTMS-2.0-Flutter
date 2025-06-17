import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/shifts/create_shift/controller/create_shift_controller.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class SelectShiftTimeRow extends StatelessWidget {
  SelectShiftTimeRow(
      {super.key, required this.title, required this.value, this.onTap});

  final String title, value;
  final GestureTapCallback? onTap;

  final controller = Get.put(CreateShiftController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 7, 50, 7),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
                child: PrimaryTextView(
              fontSize: 16,
              text: title,
            )),
            Container(
              width: 80,
              padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
              decoration: AppUtils.getGrayBorderDecoration(
                  radius: 4, color: Color(AppUtils.haxColor("#e8e8e8"))),
              child: PrimaryTextView(
                textAlign: TextAlign.center,
                text: value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
