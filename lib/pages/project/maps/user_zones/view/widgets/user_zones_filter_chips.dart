import 'package:belcka/pages/project/maps/user_zones/controller/user_zones_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/shapes/badge_count_widget.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Selected filter chips under the user zones header (same pattern as buyer orders).
class UserZonesFilterChips extends StatelessWidget {
  const UserZonesFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserZonesController>();
    return Obx(
      () => controller.filterItemsList.isEmpty
          ? const SizedBox.shrink()
          : Container(
              margin: const EdgeInsets.fromLTRB(8, 0, 8, 6),
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.filterItemsList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 0),
                itemBuilder: (context, index) {
                  final ModuleInfo info = controller.filterItemsList[index];
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if ((info.action ?? '') ==
                              AppConstants.action.reset) {
                            controller.clearFilter();
                          }
                        },
                        child: CardViewDashboardItem(
                          boxColor: backgroundColor_(context),
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            alignment: Alignment.center,
                            child: TitleTextView(
                              text: info.name ?? '',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
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
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
