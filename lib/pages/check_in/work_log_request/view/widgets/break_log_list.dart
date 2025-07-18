import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/work_log_request/controller/work_log_request_controller.dart';
import 'package:otm_inventory/pages/shifts/create_shift/model/break_info.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class BreakLogList extends StatelessWidget {
  BreakLogList({super.key, required this.breakLogList});

  final List<BreakInfo> breakLogList;
  final controller = Get.put(WorkLogRequestController());

  @override
  Widget build(BuildContext context) {
    return breakLogList.isNotEmpty
        ? CardViewDashboardItem(
            borderRadius: 15,
            margin: EdgeInsets.fromLTRB(14, 0, 14, 18),
            padding: EdgeInsets.only(top: 6, bottom: 6),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(), //
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(
                breakLogList.length,
                (position) {
                  var info = breakLogList[position];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleTextView(
                          text:
                              "${'break'.tr} (${info.breakStartTime} - ${info.breakEndTime})",
                        ),
                        TitleTextView(
                          text: getBreakLogTime(info),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        : Container();
  }

  String getBreakLogTime(BreakInfo info) {
    String time = "";
    int totalSeconds = DateUtil.dateDifferenceInSeconds(
        date1: DateUtil.getDateTimeFromHHMM(info.breakStartTime ?? ""),
        date2: DateUtil.getDateTimeFromHHMM(info.breakEndTime ?? ""));
    time = DateUtil.seconds_To_HH_MM(totalSeconds);
    return time;
  }
}
