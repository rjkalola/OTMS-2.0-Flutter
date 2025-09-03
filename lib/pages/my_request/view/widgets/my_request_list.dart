import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/my_request/controller/my_request_controller.dart';
import 'package:belcka/pages/my_request/model/my_request_info.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

import '../../../../../utils/app_constants.dart';

class MyRequestList extends StatelessWidget {
  MyRequestList({super.key});

  final controller = Get.put(MyRequestController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                MyRequestInfo info = controller.myRequestList[position];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                  child: CardViewDashboardItem(
                    borderRadius: 20,
                    child: GestureDetector(
                      onTap: () {
                        var arguments = {
                          AppConstants.intentKey.teamId: info.id ?? 0,
                        };
                        controller.moveToScreen(
                            AppRoutes.teamDetailsScreen, arguments);
                      },
                      child: Row(
                        children: [
                          UserAvtarView(imageUrl: info.userImage ?? ""),
                          Column(
                            children: [
                              TitleTextView(
                                text: "${info.userName ?? ""}:",
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: controller.myRequestList.length,
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
