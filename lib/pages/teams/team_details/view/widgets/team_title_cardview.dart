import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/teams/team_details/controller/team_details_controller.dart';
import 'package:otm_inventory/pages/teams/team_list/model/team_info.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';

class TeamTitleCardView extends StatelessWidget {
  TeamTitleCardView({super.key});

  final controller = Get.put(TeamDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: CardViewDashboardItem(
          borderRadius: 20,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.fromLTRB(14, 12, 10, 12),
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
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
                            url: controller.info.value.supervisorThumbImage,
                            width: 40,
                            height: 40,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.info.value.name ?? "",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              controller.info.value.supervisorName ?? "",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: secondaryLightTextColor,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
