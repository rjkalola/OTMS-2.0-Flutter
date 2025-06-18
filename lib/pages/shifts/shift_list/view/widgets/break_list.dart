import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/shifts/create_shift/model/break_info.dart';
import 'package:otm_inventory/pages/shifts/create_shift/model/shift_info.dart';
import 'package:otm_inventory/pages/shifts/shift_list/controller/shift_list_controller.dart';
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

class BreakList extends StatelessWidget {
  BreakList({super.key, required this.breakList});

  final List<BreakInfo> breakList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          BreakInfo info = breakList[position];
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubtitleTextView(
                  text:
                      "${'break'.tr}: ${info.breakStartTime} - ${info.breakEndTime}",
                  fontSize: 15,
                )
              ],
            ),
          );
        },
        itemCount: breakList.length,
        separatorBuilder: (context, position) => Container());
  }
}
