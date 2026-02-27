import 'package:belcka/pages/timesheet/timesheet_list/controller/timesheet_list_controller.dart';
import 'package:belcka/pages/timesheet/timesheet_list/model/time_sheet_info.dart';
import 'package:belcka/pages/timesheet/timesheet_list/view/widgets/week_log_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:belcka/widgets/other_widgets/expand_collapse_arrow_widget.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/app_constants.dart';

class TimeSheetList extends StatelessWidget {
  TimeSheetList({super.key});

  final controller = Get.put(TimeSheetListController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: RefreshIndicator(
      onRefresh: () async {
        await controller.loadTimesheetData(
            true); // Add await to ensure proper async handling
      },
      child: controller.timeSheetList.isNotEmpty
          ? ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                TimeSheetInfo info = controller.timeSheetList[position];
                return CardViewDashboardItem(
                    margin: EdgeInsets.fromLTRB(14, 7, 14, 7),
                    child: Column(
                      children: [
                        userDetailsView(info, position),
                        // WeekNumberTitle(
                        //   position: position,
                        //   info: info,
                        // ),
                        // DayLogList(
                        //   parentPosition: position,
                        // ),
                        WeekLogList(parentPosition: position),
                      ],
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
              separatorBuilder: (context, position) => Container())
          : Center(
              child: NoDataFoundWidget(),
            ),
    ));
  }

  Widget userDetailsView(TimeSheetInfo info, int position) {
    int status = info.status ?? 0;
    int time = info.totalPayableSeconds ?? 0;
    print("time" + time.toString());
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
      color: Colors.transparent,
      child: Obx(
        () => GestureDetector(
          onTap: () {
            controller.timeSheetList[position].isExpanded =
                !(controller.timeSheetList[position].isExpanded ?? false);
            controller.timeSheetList.refresh();
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            AppUtils.onClickUserAvatar(info.userId ?? 0);
                          },
                          child: UserAvtarView(
                            imageUrl: info.userThumbImage ?? "",
                            imageSize: 46,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Visibility(
                          visible: status == AppConstants.status.lock ||
                              status == AppConstants.status.unlock ||
                              status == AppConstants.status.markAsPaid,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: AppUtils.circleDecoration(
                                color: dashBoardBgColor_(Get.context!),
                                borderWidth: 0,
                                borderColor: primaryTextColor_(Get.context!)),
                            child: controller.buildStatusIcon(status),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 6,
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
                  text: controller.isViewAmount.value
                      ? "£${info.totalPayableAmount ?? "0"}"
                      : DateUtil.seconds_To_HH_MM(
                          info.totalPayableSeconds ?? 0),
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
        ),
      ),
    );
  }
}
