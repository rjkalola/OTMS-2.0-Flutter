import 'package:belcka/pages/timesheet/timesheet_list/controller/timesheet_list_controller.dart';
import 'package:belcka/pages/timesheet/timesheet_list/model/week_log_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/checkbox/custom_checkbox.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeekNumberTitle extends StatelessWidget {
  WeekNumberTitle({
    super.key,
    required this.parentPosition,
    required this.position,
  });

  final controller = Get.put(TimeSheetListController());
  int parentPosition, position;

  // WeekLogInfo info;

  @override
  Widget build(BuildContext context) {
    WeekLogInfo info =
        controller.timeSheetList[parentPosition].weekLogs![position];
    return Obx(
      () => Padding(
        padding: EdgeInsets.fromLTRB(
            !controller.isEditStatusEnable.value ? 16 : 0, 0, 16, 0),
        child: Row(
          children: [
            Visibility(
              visible: controller.isEditStatusEnable.value,
              child: CustomCheckbox(
                  onValueChange: (value) {
                    info.isCheck = !(info.isCheck ?? false);
                    controller.timeSheetList.refresh();
                    controller.checkSelectAll();
                  },
                  mValue: info.isCheck ?? false),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Divider(
                    height: 0,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                    color: backgroundColor_(context),
                    child: TitleTextView(
                      fontSize: 14,
                      text:
                          "Week ${info.weekNumber} (${info.startDateMonth} - ${info.endDateMonth})",
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
