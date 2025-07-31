import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:otm_inventory/pages/project/check_in_records/controller/check_in_records_controller.dart';
import 'package:otm_inventory/pages/project/check_in_records/model/check_in_records_info.dart';
import 'package:otm_inventory/pages/project/check_in_records/view/widgets/check_in_user_records.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/view/widgets/day_log_list.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class CheckInRecordsList extends StatelessWidget {
  CheckInRecordsList({super.key});

  final controller = Get.put(CheckInRecordsController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, position) {
              CheckInRecordsInfo info = controller.listItems[position];
              return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 6),
                        child: TitleTextView(
                          text: info.date ?? "",
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
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
            itemCount: controller.listItems.length,
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
}
