import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/shifts/create_shift/model/shift_info.dart';
import 'package:belcka/pages/shifts/shift_list/controller/shift_list_controller.dart';
import 'package:belcka/pages/shifts/shift_list/view/widgets/break_list.dart';
import 'package:belcka/pages/teams/team_list/controller/team_list_controller.dart';
import 'package:belcka/pages/teams/team_list/model/team_info.dart';
import 'package:belcka/pages/permissions/user_list/controller/user_list_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/switch/custom_switch.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

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
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleTextView(
                                    text: info.name ?? "",
                                    fontWeight: FontWeight.w500,
                                  ),
                                  Visibility(
                                    visible: !StringHelper.isEmptyString(
                                        info.showFrequncy),
                                    child: SubtitleTextView(
                                      text: info.showFrequncy ?? "",
                                      color: primaryTextColor_(context),
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  SubtitleTextView(
                                    text:
                                        "${'shift'.tr}: ${info.startTime} - ${info.endTime}",
                                    fontSize: 15,
                                  ),
                                  BreakList(breakList: info.breaks ?? [])
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CustomSwitch(
                                onValueChange: (value) {
                                  info.status = !(info.status ?? false);
                                  controller.changeShiftStatusApi(
                                      info.id ?? 0, info.status ?? false);
                                  controller.shiftList.refresh();
                                },
                                mValue: info.status ?? false)
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
