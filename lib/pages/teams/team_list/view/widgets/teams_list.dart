import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/teams/team_list/controller/team_list_controller.dart';
import 'package:belcka/pages/teams/team_list/model/team_info.dart';
import 'package:belcka/pages/permissions/user_list/controller/user_list_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/switch/custom_switch.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

import '../../../../../utils/app_constants.dart';

class TeamsList extends StatelessWidget {
  TeamsList({super.key});

  final controller = Get.put(TeamListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                TeamInfo info = controller.teamsList[position];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                  child: CardViewDashboardItem(
                    borderRadius: 20,
                    child: GestureDetector(
                      onTap: () {
                        var arguments = {
                          AppConstants.intentKey.teamId: info.id ?? 0,
                        };
                        controller.moveToScreen(
                            AppRoutes.teamDetailsScreen, arguments);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(14, 12, 10, 12),
                        color: Colors.transparent,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserAvtarView(
                              imageUrl: info.supervisorThumbImage ?? "",
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleTextView(
                                    text: (info.isSubcontractor ?? false)
                                        ? "${info.name} (${info.subcontractorCompanyName})"
                                        : info.name ?? "",
                                    color: (info.isSubcontractor ?? false)
                                        ? defaultAccentColor_(context)
                                        : primaryTextColor_(context),
                                  ),
                                  SubtitleTextView(
                                    text: info.supervisorName ?? "",
                                  ),
                                  SubtitleTextView(
                                    text: "${info.teamMemberCount} Members",
                                    fontSize: 13,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: controller.teamsList.length,
              /* separatorBuilder: (context, position) => const Padding(
                    padding: EdgeInsets.only(left: 70, right: 16),
                    child: Divider(
                      height: 0,
                      color: dividerColor,
                      thickness: 2,
                    ),
                  )),*/
              separatorBuilder: (context, position) => Container()),
        ));
  }
}
