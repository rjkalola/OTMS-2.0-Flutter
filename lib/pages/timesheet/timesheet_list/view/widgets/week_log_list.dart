import 'package:belcka/pages/timesheet/timesheet_list/controller/timesheet_list_controller.dart';
import 'package:belcka/pages/timesheet/timesheet_list/model/week_log_info.dart';
import 'package:belcka/pages/timesheet/timesheet_list/view/widgets/day_log_list.dart';
import 'package:belcka/pages/timesheet/timesheet_list/view/widgets/week_number_title.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
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
          int requestStatus = getStatus(info);
          return Obx(
            () => Visibility(
                visible: (controller.timeSheetList[parentPosition].isExpanded ??
                    false),
                child: Column(
                  children: [
                    SizedBox(
                      height: 6,
                    ),
                    Stack(
                      children: [
                        WeekNumberTitle(
                          parentPosition: parentPosition,
                          position: position,
                        ),
                        Visibility(
                          visible: requestStatus == AppConstants.status.lock ||
                              requestStatus == AppConstants.status.unlock ||
                              requestStatus == AppConstants.status.markAsPaid,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              color: backgroundColor_(context),
                              alignment: Alignment.center,
                              width: 40,
                              height: 30,
                              child: buildStatusIcon(requestStatus),
                            ),
                          ),
                        )
                      ],
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

  int getStatus(WeekLogInfo info) {
    int status = -1;
    List<int> allStatus = [];
    for (var dayLog in info.dayLogs!) {
      allStatus.add(dayLog.status ?? 0);
    }

    bool allStatusSame = allStatus.toSet().length == 1;
    if (allStatus.isNotEmpty) {
      int checkedStatus = allStatus[0];
      if (allStatus.isNotEmpty &&
          allStatusSame &&
          (checkedStatus == AppConstants.status.lock ||
              checkedStatus == AppConstants.status.unlock ||
              checkedStatus == AppConstants.status.markAsPaid)) {
        status = checkedStatus;
      }
    }
    return status;
  }

  Widget buildStatusIcon(int requestStatus) {
    if (requestStatus == AppConstants.status.lock) {
      return Icon(
        Icons.lock_outline,
        size: 20,
        color: Colors.green,
      );
    } else if (requestStatus == AppConstants.status.unlock) {
      return Icon(
        Icons.lock_open_outlined,
        size: 20,
        color: Colors.red,
      );
    } else if (requestStatus == AppConstants.status.markAsPaid) {
      return Icon(
        Icons.currency_pound_outlined,
        size: 20,
        color: defaultAccentColor_(Get.context!),
      );
    } else {
      return Container();
    }
  }
}
