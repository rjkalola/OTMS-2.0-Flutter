import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_controller.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/controller/timesheet_list_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class WeekNumberTitle extends StatelessWidget {
  WeekNumberTitle({super.key});

  final controller = Get.put(TimeSheetListController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Divider(
              height: 0,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
              color: dashBoardBgColor,
              child: TitleTextView(
                text: 'my_day_logs'.tr,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
