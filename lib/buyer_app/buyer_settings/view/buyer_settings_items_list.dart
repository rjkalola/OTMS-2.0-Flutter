import 'package:belcka/buyer_app/buyer_settings/controller/buyer_settings_controller.dart';
import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerSettingsItemsList extends StatelessWidget {
  BuyerSettingsItemsList({super.key});

  final controller = Get.put(BuyerSettingsController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            ModuleInfo info = controller.listItems[position];
            return CardViewDashboardItem(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
              borderRadius: 15,
              child: GestureDetector(
                onTap: () {
                  // var arguments = {
                  //   AppConstants.intentKey.leaveId: info.id ?? 0,
                  // };
                  // controller.moveToScreen(
                  //     AppRoutes.leaveDetailsScreen, arguments);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleTextView(
                      text: info.name ?? "",
                    ),
                    TitleTextView(
                      text: info.value ?? "",
                    )
                  ],
                ),
              ),
            );
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
          separatorBuilder: (context, position) => SizedBox(
                height: 12,
              )),
    );
  }

  String getDate(LeaveInfo info) {
    String date = "";
    if (info.isAlldayLeave ?? false) {
      date = "${info.startDate ?? ""} - ${info.endDate ?? ""}";
    } else {
      date = info.startDate ?? "";
    }
    return date;
  }

  String getTime(LeaveInfo info) {
    return "${info.startTime ?? ""} to ${info.endTime ?? ""}";
  }
}
