import 'package:belcka/pages/project/address_details/controller/address_details_controller.dart';
import 'package:belcka/pages/project/check_in_records/model/check_in_records_info.dart';
import 'package:belcka/pages/project/address_details/view/widgets/check_in_user_records.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckInRecordsList extends StatelessWidget {
  CheckInRecordsList({super.key});

  final controller = Get.put(AddressDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Expanded(
          child: controller.listCheckInRecords.isNotEmpty
              ? ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, position) {
                    CheckInRecordsInfo info =
                        controller.listCheckInRecords[position];
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
                  itemCount: controller.listCheckInRecords.length,
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
                  child: TitleTextView(
                    text: 'empty_data_message'.tr,
                  ),
                )),
    );
  }
}
