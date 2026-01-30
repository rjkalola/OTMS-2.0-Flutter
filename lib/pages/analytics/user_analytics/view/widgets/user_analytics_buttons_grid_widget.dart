import 'package:belcka/pages/analytics/user_analytics/controller/user_analytics_controller.dart';
import 'package:belcka/pages/analytics/user_analytics/model/user_analytics_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class UserAnalyticsButtonsGridWidget extends StatelessWidget {
  UserAnalyticsButtonsGridWidget({super.key});

  final UserAnalyticsController controller =
  Get.find<UserAnalyticsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final model = controller.userAnalytics.value;
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (model == null) {
        return const SizedBox();
      }

      final List<UserAnalyticsGridItem> items =
      controller.menuItems(model);

      return Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 100,
          ),
          itemBuilder: (context, index) {
            final info = items[index];

            return InkWell(
              onTap: () {
                // TODO: handle tap if needed
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: CardViewDashboardItem(
                padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                child: Row(
                  children: [
                    Icon(
                      info.iconData,
                      color: info.color,
                      size: 35,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PrimaryTextView(
                            text: info.title,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            textAlign: TextAlign.center,
                            color:
                            primaryTextColorLight_(context),
                            softWrap: true,
                            maxLine: 2,
                          ),
                          const SizedBox(height: 4),
                          PrimaryTextView(
                            text: info.value,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            textAlign: TextAlign.center,
                            color: Colors.grey[600],
                            softWrap: true,
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
        ),
      );
    });
  }
}