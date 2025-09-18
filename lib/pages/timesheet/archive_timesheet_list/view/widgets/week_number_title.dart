import 'package:belcka/pages/timesheet/archive_timesheet_list/controller/archive_timesheet_list_controller.dart';
import 'package:belcka/pages/timesheet/timesheet_list/model/time_sheet_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeekNumberTitle extends StatelessWidget {
  WeekNumberTitle({super.key, required this.position, required this.info});

  final controller = Get.put(ArchiveTimesheetListController());
  int position;
  TimeSheetInfo info;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: !(controller.timeSheetList[position].isExpanded ?? false),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
        ),
      ),
    );
  }
}
