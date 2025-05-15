import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/controller/home_tab_controller.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/model/pie_chart_info.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';

class WorkLogDetailsView extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  WorkLogDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 14, 12),
        child: Row(children: [
          Container(
            padding: EdgeInsets.all(9),
            width: 40,
            height: 40,
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Center(
              child: Column(
                children: [
                  Text(
                      scheduleWorkTime(
                          controller.dashboardResponse.value.shiftStartTime,
                          controller.dashboardResponse.value.shiftEndTime),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: secondaryLightTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      )),
                  SizedBox(
                    height: 3,
                  ),
                  Text(controller.totalWorkHours.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      )),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                      "Work Started: ${DateUtil.changeDateFormat(controller.dashboardResponse.value.checkinDateTime ?? "", DateUtil.YYYY_MM_DD_TIME_24_DASH2, DateUtil.DD_MMM_EEE_COMMA_SPACE_HH_MM_24)}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: secondaryLightTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      )),
                ],
              ),
            ),
          )),
          Icon(
            Icons.keyboard_arrow_right,
            size: 24,
            color: defaultAccentColor,
          ),
        ]),
      ),
    );
  }

  String scheduleWorkTime(String? startTime, String? endTime) {
    var timeRange = "";
    if (!StringHelper.isEmptyString(startTime) &&
        !StringHelper.isEmptyString(endTime)) {
      String startFormattedTime = DateUtil.changeDateFormat(
          startTime!, DateUtil.HH_MM_SS_24_2, DateUtil.HH_MM_24);
      String endFormattedTime = DateUtil.changeDateFormat(
          endTime!, DateUtil.HH_MM_SS_24_2, DateUtil.HH_MM_24);
      timeRange = "Scheduled Work $startFormattedTime - $endFormattedTime";
    }
    return timeRange;
  }
}
