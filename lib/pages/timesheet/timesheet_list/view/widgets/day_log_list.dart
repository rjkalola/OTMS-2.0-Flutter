import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/controller/timesheet_list_controller.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/model/day_log_info.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/model/time_sheet_info.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/right_arrow_widget.dart';
import 'package:otm_inventory/widgets/text/SubTitleTextView.dart';
import 'package:otm_inventory/widgets/text/TextViewWithContainer.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class DayLogList extends StatelessWidget {
  DayLogList({super.key, required this.parentPosition});

  final controller = Get.put(TimeSheetListController());
  final int parentPosition;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          print("parentPosition:" + parentPosition.toString());
          print("position:" + position.toString());
          DayLogInfo info =
              controller.timeSheetList[parentPosition].dayLogs![position];
          return Obx(() => Visibility(
              visible: !(controller.timeSheetList[parentPosition].isExpanded ??
                  false),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 9, 13, 9),
                child: Row(
                  children: [
                    dayDate(info),
                    SizedBox(
                      width: 4,
                    ),
                    shiftName(info),
                    Expanded(child: Container()),
                    totalWorkHour(info),
                    SizedBox(
                      width: 4,
                    ),
                    RightArrowWidget(
                      color: primaryTextColor,
                    )
                  ],
                ),
              )),);
        },
        itemCount: controller.timeSheetList[parentPosition].dayLogs!.length,
        // separatorBuilder: (context, position) => const Padding(
        //   padding: EdgeInsets.only(left: 100),
        //   child: Divider(
        //     height: 0,
        //     color: dividerColor,
        //     thickness: 0.8,
        //   ),
        // ),
        separatorBuilder: (context, position) => Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Divider(
                height: 0,
                color: dividerColor,
              ),
            ));
  }

  Widget dayDate(DayLogInfo info) => CardViewDashboardItem(
        borderRadius: 15,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Column(
            children: [
              TitleTextView(
                text: info.dayDateInt,
                fontSize: 14,
              ),
              TitleTextView(
                text: info.day,
                fontSize: 14,
              )
            ],
          ),
        ),
      );

  Widget shiftName(DayLogInfo info) => TextViewWithContainer(
        text: info.shiftName ?? "",
        padding: EdgeInsets.fromLTRB(6, 1, 6, 1),
        fontColor: primaryTextColor,
        fontSize: 15,
        boxColor: Color(AppUtils.haxColor("#ACDBFE")),
        borderRadius: 5,
      );

  Widget totalWorkHour(DayLogInfo info) => Column(
        children: [
          TitleTextView(
            text: DateUtil.seconds_To_HH_MM(info.totalSeconds ?? 0),
            fontSize: 17,
          ),
          SubtitleTextView(
            text: "(${info.startTimeFormat} - ${info.endTimeFormat})",
            fontSize: 13,
          )
        ],
      );
}
