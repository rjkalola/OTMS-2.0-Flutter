import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/controller/timesheet_list_controller.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/model/day_log_info.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/model/time_sheet_info.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/right_arrow_widget.dart';
import 'package:otm_inventory/widgets/shapes/badge_count_widget.dart';
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
          return Obx(
            () => Visibility(
                visible:
                    !(controller.timeSheetList[parentPosition].isExpanded ??
                        false),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 12, 13, 12),
                      child: GestureDetector(
                        onTap: () {
                          controller.onClickWorkLogItem(
                              info.id ?? 0,
                              controller.timeSheetList[parentPosition].userId ??
                                  0);
                        },
                        child: Container(
                          color: Colors.transparent,
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
                                color: primaryTextColor_(context),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Visibility(
                        visible: (info.userCheckLogsCount ?? 0) != 0,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16, top: 6),
                          child: CustomBadgeIcon(
                            count: info.userCheckLogsCount ?? 0,
                            color: defaultAccentColor_(context),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          );
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
                color: dividerColor_(context),
              ),
            ));
  }

  Widget dayDate(DayLogInfo info) => CardViewDashboardItem(
        borderRadius: 15,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: SizedBox(
            width: 50,
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
        ),
      );

  Widget shiftName(DayLogInfo info) => TextViewWithContainer(
        text: info.shiftName ?? "",
        padding: EdgeInsets.fromLTRB(6, 1, 6, 1),
        fontColor: ThemeConfig.isDarkMode ? Colors.white : Colors.black,
        fontSize: 15,
        boxColor:
            ThemeConfig.isDarkMode ? Color(0xFF4BA0F3) : Color(0xffACDBFE),
        borderRadius: 5,
      );

  Widget totalWorkHour(DayLogInfo info) => Column(
        children: [
          TitleTextView(
            text: (info.isPricework ?? false)
                ? "£${info.priceWorkTotalAmount ?? "0"}"
                : DateUtil.seconds_To_HH_MM(info.payableWorkSeconds ?? 0),
            color: info.requestStatus != null
                ? AppUtils.getStatusColor(info.requestStatus ?? 0)
                : primaryTextColor_(Get.context!),
            fontSize: 17,
          ),
          SubtitleTextView(
            text: "(${info.startTimeFormat} - ${info.endTimeFormat})",
            fontSize: 13,
          )
        ],
      );
}
