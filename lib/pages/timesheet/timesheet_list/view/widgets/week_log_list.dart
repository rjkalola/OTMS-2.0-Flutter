import 'package:belcka/pages/timesheet/timesheet_list/controller/timesheet_list_controller.dart';
import 'package:belcka/pages/timesheet/timesheet_list/model/week_log_info.dart';
import 'package:belcka/pages/timesheet/timesheet_list/view/widgets/day_log_list.dart';
import 'package:belcka/pages/timesheet/timesheet_list/view/widgets/week_number_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeekLogList extends StatelessWidget {
  WeekLogList({super.key, required this.parentPosition});

  final controller = Get.put(TimeSheetListController());
  final int parentPosition;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          WeekLogInfo info =
              controller.timeSheetList[parentPosition].weekLogs![position];
          return Obx(
            () => Visibility(
                visible:
                    !(controller.timeSheetList[parentPosition].isExpanded ??
                        false),
                child: Column(
                  children: [
                    SizedBox(
                      height: 6,
                    ),
                    WeekNumberTitle(
                      parentPosition: parentPosition,
                      position: position,
                    ),
                    DayLogList(
                      parentPosition: parentPosition,
                      weekPosition: position,
                    ),
                  ],
                )),
          );
        },
        itemCount: controller.timeSheetList[parentPosition].weekLogs!.length,
        separatorBuilder: (context, position) => SizedBox(
              height: 0,
            ));
  }
}
