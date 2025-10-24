import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/teams/team_details/controller/team_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

class TeamTitleCardView extends StatelessWidget {
  TeamTitleCardView({super.key});

  final controller = Get.put(TeamDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: CardViewDashboardItem(
          borderRadius: 20,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.fromLTRB(14, 12, 10, 12),
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      AppUtils.onClickUserAvatar(controller.teamInfo.value.supervisorId ?? 0);
                    },
                    child: UserAvtarView(
                      imageUrl:
                          controller.teamInfo.value.supervisorThumbImage ?? "",
                      imageSize: 50,
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleTextView(
                          text: controller.teamInfo.value.supervisorName ?? "",
                        ),
                        Visibility(
                          visible: !StringHelper.isEmptyString(
                              controller.teamInfo.value.supervisorTrade),
                          child: SubtitleTextView(
                            text:
                                controller.teamInfo.value.supervisorTrade ?? "",
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        GestureDetector(
                          onTap: () {
                            AppUtils.onClickPhoneNumber(controller.teamInfo
                                    .value.supervisorPhoneWithExtension ??
                                "");
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 18,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              PrimaryTextView(
                                  text: controller.teamInfo.value
                                          .supervisorPhoneWithExtension ??
                                      "",
                                  fontSize: 14,
                                  color: primaryTextColor_(context))
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
