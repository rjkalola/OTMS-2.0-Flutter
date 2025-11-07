import 'package:belcka/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:belcka/pages/project/address_details/controller/address_details_controller.dart';
import 'package:belcka/pages/project/check_in_records/model/check_in_records_info.dart';
import 'package:belcka/pages/project/address_details/view/widgets/check_in_user_records.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckInRecordsList extends StatelessWidget {
  CheckInRecordsList({super.key, required this.searchText});

  final String searchText;
  final controller = Get.put(AddressDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filteredRecords = controller.listCheckInRecords.map((record) {
        final filteredData = (record.data ?? []).where((log) {
          if (StringHelper.isEmptyString(searchText)) return true;
          final name = log.userName?.toLowerCase() ?? '';
          return name.contains(searchText.toLowerCase());
        }).toList();
        return CheckInRecordsInfo(
          date: record.date,
          data: filteredData,
        );
      }).where((r) => (r.data?.isNotEmpty ?? false)).toList();

      return Expanded(
        child: filteredRecords.isNotEmpty
            ? ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final info = filteredRecords[index];
            return Container(
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                    child: TitleTextView(
                      text: info.date ?? "",
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  CheckInUserRecords(
                    parentPosition: index,
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            );
          },
          separatorBuilder: (context, _) => const SizedBox(height: 0),
          itemCount: filteredRecords.length,
        )
            : Center(
          child: TitleTextView(
            text: 'empty_data_message'.tr,
          ),
        ),
      );
    });
  }
}
