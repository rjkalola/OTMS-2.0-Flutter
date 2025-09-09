import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/pages/project/project_list/controller/project_list_controller.dart';
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

class ProjectsList extends StatelessWidget {
  ProjectsList({super.key});

  final controller = Get.put(ProjectListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                ProjectInfo info = controller.projectsList[position];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                  child: CardViewDashboardItem(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    child: InkWell(
                      onTap: () {
                        var arguments = {
                          AppConstants.intentKey.projectId: info.id ?? 0,
                        };
                        controller.moveToScreen(
                            AppRoutes.projectDetailsScreen, arguments);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              info.name ?? "",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              maxLines: null,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: primaryTextColor_(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: controller.projectsList.length,
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
