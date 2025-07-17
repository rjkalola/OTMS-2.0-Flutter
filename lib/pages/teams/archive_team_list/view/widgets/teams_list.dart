import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/teams/archive_team_list/controller/archive_team_list_controller.dart';
import 'package:otm_inventory/pages/teams/team_list/model/team_info.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';
import 'package:otm_inventory/widgets/text/SubTitleTextView.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

import '../../../../../utils/app_constants.dart';

class TeamsList extends StatelessWidget {
  TeamsList({super.key});

  final controller = Get.put(ArchiveTeamListController());

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
                        /* var arguments = {
                          AppConstants.intentKey.teamId: info.id ?? 0,
                        };
                        controller.moveToScreen(
                            AppRoutes.teamDetailsScreen, arguments);*/
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(14, 12, 10, 12),
                        color: Colors.transparent,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                        ? defaultAccentColor
                                        : primaryTextColor_(context),
                                  ),
                                  SubtitleTextView(
                                    text: info.supervisorName ?? "",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.unArchiveTeamApi(
                                    info.id ?? 0, position);
                              },
                              child: ImageUtils.setSvgAssetsImage(
                                  path: Drawable.unArchiveIcon,
                                  color: defaultAccentColor,
                                  width: 28,
                                  height: 28),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.showDeleteTeamDialog(
                                    info.id ?? 0, position);
                              },
                              child: ImageUtils.setSvgAssetsImage(
                                  path: Drawable.deletePermanentIcon,
                                  color: Colors.red,
                                  width: 24,
                                  height: 24),
                            )
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
