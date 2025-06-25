import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/permissions/user_list/controller/user_list_controller.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/controller/timesheet_list_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/expand_collapse_arrow_widget.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';
import 'package:otm_inventory/widgets/switch/custom_switch.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

import '../../../../../../utils/app_constants.dart';

class TimeSheetList extends StatelessWidget {
  TimeSheetList({super.key});

  final controller = Get.put(TimeSheetListController());

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          // UserInfo info = controller.usersList[position];
          return CardViewDashboardItem(
              child: Column(
            children: [userDetailsView()],
          ));
        },
        itemCount: 4,
        // separatorBuilder: (context, position) => const Padding(
        //   padding: EdgeInsets.only(left: 100),
        //   child: Divider(
        //     height: 0,
        //     color: dividerColor,
        //     thickness: 0.8,
        //   ),
        // ),
        separatorBuilder: (context, position) => Container());
  }

  Widget userDetailsView() => Container(
        padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
        color: Colors.transparent,
        child: Row(
          children: [
            UserAvtarView(
              imageUrl: "",
              imageSize: 52,
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryTextView(
                    text: "Ravi Kalola",
                    fontSize: 17,
                    color: primaryTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                  PrimaryTextView(
                    text: "",
                    fontSize: 14,
                    color: secondaryLightTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 12,
            ),
            ExpandCollapseArrowWidget(isOpen: false),
            SizedBox(
              width: 6,
            ),
          ],
        ),
      );
}
