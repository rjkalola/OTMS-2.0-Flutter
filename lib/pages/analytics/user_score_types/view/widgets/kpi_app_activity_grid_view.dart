import 'package:belcka/pages/analytics/user_analytics/model/user_analytics_grid_item.dart';
import 'package:belcka/pages/analytics/user_score_types/controller/user_score_types_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class KpiAppActivityGridView extends StatelessWidget {
  KpiAppActivityGridView({super.key});

  final controller = Get.find<UserScoreTypesController>();

  @override
  Widget build(BuildContext context) {
    final model = controller.userAnalytics.value;
    final type = controller.userScoreType.value.value;

    if (model == null) {
      return const SizedBox();
    }

    final List<UserAnalyticsGridItem> items = type == 2 ? controller.kpiMenuItems(model) : controller.appActivityMenuItems(model);

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 100,
      ),
      itemBuilder: (context, index) {
        final info = items[index];
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {},
          child: CardViewDashboardItem(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
            child: Row(
              children: [
                Icon(info.iconData, color: info.color, size: 35),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PrimaryTextView(
                        text: info.title,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        textAlign: TextAlign.center,
                        color: primaryTextColorLight_(context),
                        maxLine: 2,
                      ),
                      const SizedBox(height: 4),
                      PrimaryTextView(
                        text: info.value,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        textAlign: TextAlign.center,
                        color: Colors.grey[600],
                        maxLine: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}