import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/controller/timesheet_list_controller.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/model/day_log_info.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/model/time_sheet_info.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/right_arrow_widget.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';
import 'package:otm_inventory/widgets/shapes/badge_count_widget.dart';
import 'package:otm_inventory/widgets/text/SubTitleTextView.dart';
import 'package:otm_inventory/widgets/text/TextViewWithContainer.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class CheckInUserRecords extends StatelessWidget {
  CheckInUserRecords({super.key, required this.parentPosition});

  // final controller = Get.put(TimeSheetListController());
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
          // DayLogInfo info =
          //     controller.timeSheetList[parentPosition].dayLogs![position];
          return CardViewDashboardItem(
            margin: const EdgeInsets.fromLTRB(9, 4, 9, 4),
            padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        UserAvtarView(imageUrl: ""),
                        SizedBox(
                          width: 9,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleTextView(
                                text: "Ramil Veliiev",
                              ),
                              shiftName("Kitchen Instalation"),
                            ],
                          ),
                        ),
                        // totalWorkHour(info),
                        totalWorkHour(),
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
                Align(
                  alignment: Alignment.topRight,
                  child: Visibility(
                    visible: false,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, top: 6),
                      child: CustomBadgeIcon(
                        count: 0,
                        color: defaultAccentColor_(context),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
        itemCount: 2,
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

  Widget shiftName(String? name) => !StringHelper.isEmptyString(name)
      ? Padding(
        padding: const EdgeInsets.only(top: 4),
        child: TextViewWithContainer(
            text: name ?? "",
            padding: EdgeInsets.fromLTRB(6, 1, 6, 1),
            fontColor: ThemeConfig.isDarkMode ? Colors.white : Colors.black,
            fontSize: 15,
            boxColor:
                ThemeConfig.isDarkMode ? Color(0xFF4BA0F3) : Color(0xffACDBFE),
            borderRadius: 5,
          ),
      )
      : Container();

  /* Widget totalWorkHour(CheckLogInfo info) =>
      Column(
        children: [
          TitleTextView(
            text: DateUtil.seconds_To_HH_MM(info.totalWorkSeconds ?? 0),
            color: primaryTextColor_(Get.context!),
            fontSize: 17,
          ),
          SubtitleTextView(
            text: "(${info.checkinDateTime} - ${info.checkoutDateTime})",
            fontSize: 13,
          )
        ],
      );*/

  Widget totalWorkHour() => Column(
        children: [
          TitleTextView(
            text: DateUtil.seconds_To_HH_MM(0),
            color: primaryTextColor_(Get.context!),
            fontSize: 17,
          ),
          SubtitleTextView(
            text: "(9:00 - 15:00)",
            fontSize: 13,
          )
        ],
      );
}
