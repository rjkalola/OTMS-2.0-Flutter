import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/permissions/user_list/controller/user_list_controller.dart';
import 'package:otm_inventory/pages/teams/create_team/controller/create_team_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/switch/custom_switch.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

import '../../../../../../utils/app_constants.dart';

class TeamMembersList extends StatelessWidget {
  TeamMembersList({super.key});

  final controller = Get.put(CreateTeamController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Expanded(
        child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, position) {
              UserInfo info = controller.teamMembersList[position];
              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                child: GestureDetector(
                  onTap: () {},
                  child: CardViewDashboardItem(
                      borderRadius: 20,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(45),
                                ),
                                border: Border.all(
                                  width: 2,
                                  color: Color(0xff1E1E1E),
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: ImageUtils.setUserImage(
                                url: info.userThumbImage,
                                width: 44,
                                height: 44,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryTextView(
                                    text: info.name ?? "John Doe",
                                    fontSize: 17,
                                    color: primaryTextColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  PrimaryTextView(
                                    text: info.name ?? "Android Developer",
                                    fontSize: 14,
                                    color: secondaryLightTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.teamMembersList.removeAt(position);
                                controller.teamMembersList.refresh();
                              },
                              child: Container(
                                padding: EdgeInsets.all(4),
                                width: 26,
                                height: 30,
                                child: ImageUtils.setSvgAssetsImage(
                                    path: Drawable.deleteTeamIcon,
                                    width: 20,
                                    fit: BoxFit.fill,
                                    height: 20),
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              );
            },
            itemCount: controller.teamMembersList.length,
            // separatorBuilder: (context, position) => const Padding(
            //   padding: EdgeInsets.only(left: 100),
            //   child: Divider(
            //     height: 0,
            //     color: dividerColor,
            //     thickness: 0.8,
            //   ),
            // ),
            separatorBuilder: (context, position) => Container()),
      ),
    );
  }
}
