import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/project/check_in_records/view/widgets/check_in_user_records.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/view/widgets/day_log_list.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class CheckInRecordsList extends StatelessWidget {
  CheckInRecordsList({super.key});

  // final controller = Get.put(TimeSheetListController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: RefreshIndicator(
      onRefresh: () async {
        // await controller.loadTimesheetData(true); // Add await to ensure proper async handling
      },
      child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            // TimeSheetInfo info = controller.timeSheetList[position];
            return Container(
                margin: EdgeInsets.fromLTRB(14, 7, 14, 7),
                child: Column(
                  children: [
                    TitleTextView(
                      text: "Mon 01/03/2025",
                    ),
                    CheckInUserRecords(
                      parentPosition: position,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                  ],
                ));
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
          separatorBuilder: (context, position) => Container()),
    ));
  }
}
