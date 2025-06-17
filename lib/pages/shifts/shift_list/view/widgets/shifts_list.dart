import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/shifts/create_shift/model/shift_info.dart';
import 'package:otm_inventory/pages/shifts/shift_list/controller/shift_list_controller.dart';
import 'package:otm_inventory/pages/shifts/shift_list/view/widgets/break_list.dart';
import 'package:otm_inventory/pages/teams/team_list/controller/team_list_controller.dart';
import 'package:otm_inventory/pages/teams/team_list/model/team_info.dart';
import 'package:otm_inventory/pages/permissions/user_list/controller/user_list_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';
import 'package:otm_inventory/widgets/switch/custom_switch.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:otm_inventory/widgets/text/SubTitleTextView.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

import '../../../../../utils/app_constants.dart';

class ShiftsList extends StatelessWidget {
  ShiftsList({super.key});

  final controller = Get.put(ShiftListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                ShiftInfo info = controller.shiftList[position];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                  child: CardViewDashboardItem(
                    borderRadius: 20,
                    child: GestureDetector(
                      onTap: () {
                        var arguments = {
                          AppConstants.intentKey.shiftInfo: info,
                        };
                        controller.moveToScreen(
                            AppRoutes.createShiftScreen, arguments);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleTextView(
                              text: info.name ?? "",
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            SubtitleTextView(
                              text:
                                  "${'shift'.tr}: ${info.startTime} - ${info.endTime}",
                            ),
                            BreakList(breakList: info.breaks ?? [])
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: controller.shiftList.length,
              separatorBuilder: (context, position) => Container()),
        ));
  }
}
