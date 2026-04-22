import 'package:belcka/pages/leaves/leave_history/controller/leave_history_controller.dart';
import 'package:belcka/pages/leaves/leave_history/model/leave_history_response.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveHistoryList extends StatelessWidget {
  LeaveHistoryList({super.key});

  final controller = Get.put(LeaveHistoryController());

  @override
  Widget build(BuildContext context) {
    if (controller.listItems.isEmpty) {
      return const Center(child: NoDataFoundWidget());
    }

    return ListView.separated(
      padding: const EdgeInsets.only(top: 6, bottom: 12),
      itemCount: controller.listItems.length,
      itemBuilder: (context, index) {
        final LeaveHistoryInfo info = controller.listItems[index];
        final showPaidBadge = !StringHelper.isEmptyString(info.actionBy);
        return Stack(
          children: [
            CardViewDashboardItem(
              borderRadius: 14,
              margin: const EdgeInsets.fromLTRB(12, 7, 12, 7),
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3,),
                  TitleTextView(
                    text: "${info.userName ?? '-'}:",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 0),
                  SubtitleTextView(
                    text: info.message ?? "",
                    fontSize: 15,
                    softWrap: true,
                  ),
                  const SizedBox(height: 3),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SubtitleTextView(
                      text: info.date ?? "",
                      fontSize: 13,
                      color: primaryTextColor_(context).withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: showPaidBadge,
              child: Align(
                alignment: Alignment.topLeft,
                child: TextViewWithContainer(
                  margin: const EdgeInsets.only(left: 34, top: 0),
                  text: info.leaveType??"",
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  boxColor: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
