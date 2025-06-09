import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/permissions/user_list/controller/user_list_controller.dart';
import 'package:otm_inventory/pages/teams/create_team/controller/create_team_controller.dart';
import 'package:otm_inventory/pages/teams/team_details/controller/team_details_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';
import 'package:otm_inventory/widgets/switch/custom_switch.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

import '../../../../../../utils/app_constants.dart';

class TeamMembersList extends StatelessWidget {
  TeamMembersList({super.key});

  final controller = Get.put(TeamDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.teamInfo.value.teamMembers!.isNotEmpty,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: CardViewDashboardItem(
            child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, position) {
                  UserInfo info =
                      controller.teamInfo.value.teamMembers![position];
                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: Row(
                        children: [
                          UserAvtarView(
                            imageUrl: info.userThumbImage ?? "",
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PrimaryTextView(
                                  text: info.name ?? "",
                                  fontSize: 17,
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                PrimaryTextView(
                                  text: info.tradeName ?? "",
                                  fontSize: 14,
                                  color: secondaryLightTextColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: controller.teamInfo.value.teamMembers!.length,
                // separatorBuilder: (context, position) => const Padding(
                //   padding: EdgeInsets.only(left: 100),
                //   child: Divider(
                //     height: 0,
                //     color: dividerColor,
                //     thickness: 0.8,
                //   ),
                // ),
                separatorBuilder: (context, position) => Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Divider(
                        height: 0,
                      ),
                    )),
          ),
        ),
      ),
    );
  }
}
