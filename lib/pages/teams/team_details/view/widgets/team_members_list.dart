import 'package:belcka/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/permissions/user_list/controller/user_list_controller.dart';
import 'package:belcka/pages/teams/create_team/controller/create_team_controller.dart';
import 'package:belcka/pages/teams/team_details/controller/team_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/switch/custom_switch.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

import '../../../../../../utils/app_constants.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/teams/team_details/controller/team_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';

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
              /// 🔹 Member Count Header (Fixed inside card)
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

              Expanded(
                child: ListView.separated(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    UserInfo info = members[index];

                    return GestureDetector(
                      onTap: () {
                        AppUtils.onClickUserAvatar(info.id ?? 0);
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                          child: Row(
                            children: [
                              UserAvtarView(
                                imageUrl: info.userThumbImage ?? "",
                              ),
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
              ),
            ],
          ),
        ),
      );
    });
  }
}
