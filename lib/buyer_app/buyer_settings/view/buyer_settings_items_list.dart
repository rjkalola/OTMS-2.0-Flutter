import 'package:belcka/buyer_app/buyer_settings/controller/buyer_settings_controller.dart';
import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerSettingsItemsList extends StatelessWidget {
  BuyerSettingsItemsList({super.key});

  final controller = Get.put(BuyerSettingsController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            ModuleInfo info = controller.listItems[position];
            return GestureDetector(
              onTap: () {
                controller.onItemClick(info.action ?? "");
              },
              child: CardViewDashboardItem(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                borderRadius: 15,
                child: Row(
                  children: [
                    Expanded(
                      child: TitleTextView(
                        text: info.name ?? "",
                      ),
                    ),
                    TitleTextView(
                      text: info.value ?? "",
                    ), 
                    ((info.action ?? "") == AppConstants.action.draftOrders ||
                            (info.action ?? "") ==
                                AppConstants.action.generateReport)
                        ? RightArrowWidget()
                        : Container()
                  ],
                ),
              ),
            );
          },
          itemCount: controller.listItems.length,
          // separatorBuilder: (context, position) => const Padding(
          //   padding: EdgeInsets.only(left: 100),
          //   child: Divider(
          //     height: 0,
          //     color: dividerColor,
          //     thickness: 0.8,
          //   ),
          // ),
          separatorBuilder: (context, position) => SizedBox(
                height: 12,
              )),
    );
  }
}
