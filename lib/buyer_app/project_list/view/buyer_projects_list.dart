import 'package:belcka/buyer_app/buyer_settings/controller/buyer_settings_controller.dart';
import 'package:belcka/buyer_app/project_list/controller/buyer_projects_controller.dart';
import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerProjectsList extends StatelessWidget {
  BuyerProjectsList({super.key});

  final controller = Get.put(BuyerProjectsController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            ModuleInfo info = controller.listItems[position];
            return CardViewDashboardItem(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
              borderRadius: 15,
              child: GestureDetector(
                onTap: () {
                  // var arguments = {
                  //   AppConstants.intentKey.leaveId: info.id ?? 0,
                  // };
                  // controller.moveToScreen(
                  //     AppRoutes.leaveDetailsScreen, arguments);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleTextView(
                      text: info.name ?? "",
                    ),
                    TitleTextView(
                      text: (info.productsCount ?? 0).toString(),
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: controller.listItems.length,
          separatorBuilder: (context, position) => SizedBox(
                height: 12,
              )),
    );
  }
}
