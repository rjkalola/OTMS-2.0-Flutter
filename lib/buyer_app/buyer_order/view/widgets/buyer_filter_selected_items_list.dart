import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/shapes/badge_count_widget.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_constants.dart';
import '../../controller/buyer_order_controller.dart';

class BuyerFilterSelectedItemsList extends StatelessWidget {
  final controller = Get.find<BuyerOrderController>();

  BuyerFilterSelectedItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.filterItemsList.isNotEmpty
          ? Container(
              margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.filterItemsList.length,
                separatorBuilder: (context, index) => SizedBox(width: 0),
                itemBuilder: (context, index) {
                  ModuleInfo info = controller.filterItemsList[index];
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if ((info.action ?? "") ==
                              AppConstants.action.reset) {
                            controller.clearFilter();
                          }
                        },
                        child: CardViewDashboardItem(
                            boxColor: backgroundColor_(context),
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                              alignment: Alignment.center,
                              child: TitleTextView(
                                text: info.name ?? "",
                                textAlign: TextAlign.center,
                              ),
                            )),
                      ),
                      Visibility(
                        visible: (info.count ?? 0) > 0,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CustomBadgeIcon(
                            count: info.count ?? 0,
                            color: defaultAccentColor_(context),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            )
          : Container(),
    );
  }
}
