import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/teams/team_details/controller/team_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamMembersList extends StatelessWidget {
  TeamMembersList({super.key});

  final controller = Get.find<TeamDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final members = controller.teamInfo.value.teamMembers ?? [];

      if (members.isEmpty) {
        return const SizedBox();
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
        child: CardViewDashboardItem(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 14, 18, 14),
                width: double.infinity,
                child: PrimaryTextView(
                  textAlign: TextAlign.right,
                  color: primaryTextColor_(context),
                  fontSize: 14,
                  text: "${members.length} Members",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  height: 0,
                  color: dividerColor_(context),
                ),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: members.length,
                itemBuilder: (context, index) {
                  UserInfo info = members[index];
                  return GestureDetector(
                    onTap: () {
                      if (!(controller.teamInfo.value.isSubcontractor ??
                          false)) {
                        AppUtils.onClickUserAvatar(info.id ?? 0);
                      } else {
                        AppUtils.showToastMessage('user_not_exist_message'.tr);
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: Row(
                          children: [
                            UserAvtarView(
                                imageUrl: info.userThumbImage ?? "",
                                isOnlineStatusVisible: true,
                                onlineStatusSize: 10,
                                onlineStatusColor: (info.statusColor != null &&
                                        info.statusColor!.startsWith("#"))
                                    ? AppUtils.getColor(
                                        info.statusColor ?? "#FF1744")
                                    : Colors.redAccent),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleTextView(
                                    text: info.name ?? "",
                                  ),
                                  SubtitleTextView(
                                    text: info.tradeName ?? "",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    height: 0,
                    color: dividerColor_(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
