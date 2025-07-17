import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class MyDayLogsTitle extends StatelessWidget {
  MyDayLogsTitle({super.key});

  final controller = Get.put(ClockInController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.workLogData.value.workLogInfo ?? []).isNotEmpty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Divider(
                    height: 0,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                    color: dashBoardBgColor_(context),
                    child: TitleTextView(
                      text: 'my_day_logs'.tr,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            )
          : Container(),
    );
  }
}
