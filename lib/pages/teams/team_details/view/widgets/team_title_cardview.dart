import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/teams/team_details/controller/team_details_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:otm_inventory/widgets/text/SubTitleTextView.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserAvtarView(
                    imageUrl:
                        controller.teamInfo.value.supervisorThumbImage ?? "",
                    imageSize: 50,
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
                        SubtitleTextView(
                          text: controller.teamInfo.value.supervisorTrade ?? "",
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
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
                                color: primaryTextColor)
                          ],
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
