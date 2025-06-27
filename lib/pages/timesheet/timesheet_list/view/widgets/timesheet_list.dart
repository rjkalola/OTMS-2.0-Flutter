import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/permissions/user_list/controller/user_list_controller.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/controller/timesheet_list_controller.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/model/time_sheet_info.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/view/widgets/day_log_list.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/view/widgets/week_number_title.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/expand_collapse_arrow_widget.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';
import 'package:otm_inventory/widgets/switch/custom_switch.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:otm_inventory/widgets/text/SubTitleTextView.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

import '../../../../../../utils/app_constants.dart';

class TimeSheetList extends StatelessWidget {
  TimeSheetList({super.key});

  final controller = Get.put(TimeSheetListController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, position) {
              TimeSheetInfo info = controller.timeSheetList[position];
              return CardViewDashboardItem(
                  margin: EdgeInsets.fromLTRB(14, 7, 14, 7),
                  child: GestureDetector(
                    onTap: () {
                      controller.timeSheetList[position].isExpanded =
                          !(controller.timeSheetList[position].isExpanded ??
                              false);
                      controller.timeSheetList.refresh();
                    },
                    child: Column(
                      children: [
                        userDetailsView(info,position),
                        WeekNumberTitle(
                          position: position,
                          info: info,
                        ),
                        DayLogList(
                          parentPosition: position,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ));
            },
            itemCount: controller.timeSheetList.length,
            // separatorBuilder: (context, position) => const Padding(
            //   padding: EdgeInsets.only(left: 100),
            //   child: Divider(
            //     height: 0,
            //     color: dividerColor,
            //     thickness: 0.8,
            //   ),
            // ),
            separatorBuilder: (context, position) => Container()));
  }

  Widget userDetailsView(TimeSheetInfo info, int position) => Container(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
        color: Colors.transparent,
        child: Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UserAvtarView(
                imageUrl: info.userThumbImage ?? "",
                imageSize: 46,
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleTextView(
                      text: info.userName ?? "",
                    ),
                    SubtitleTextView(
                      text: info.tradeName ?? "",
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              TitleTextView(
                text: DateUtil.seconds_To_HH_MM(info.totalHours ?? 0),
                fontSize: 17,
              ),
              SizedBox(
                width: 10,
              ),
              ExpandCollapseArrowWidget(
                  isOpen:
                      controller.timeSheetList[position].isExpanded ?? false),
              SizedBox(
                width: 6,
              ),
            ],
          ),
        ),
      );
}
