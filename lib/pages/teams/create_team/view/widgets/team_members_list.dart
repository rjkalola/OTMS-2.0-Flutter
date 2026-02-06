import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/teams/create_team/controller/create_team_controller.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                  onTap: () {
                    AppUtils.onClickUserAvatar(info.id ?? 0);
                  },
                  child: CardViewDashboardItem(
                      borderRadius: 20,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
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
                                  TitleTextView(
                                    text: info.name ?? "",
                                  ),
                                  SubtitleTextView(text: info.tradeName ?? ""),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.isSaveEnable.value = true;
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
