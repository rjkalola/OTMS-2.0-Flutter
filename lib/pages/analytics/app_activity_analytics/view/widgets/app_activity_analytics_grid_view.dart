import 'package:belcka/pages/analytics/app_activity_analytics/controller/app_activity_analytics_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppActivityAnalyticsGridView extends StatelessWidget {
  AppActivityAnalyticsGridView({super.key});

  final controller = Get.find<AppActivityAnalyticsController>();

  @override
  Widget build(BuildContext context) {
    final data = controller.appActivityScore.value;
    if (data == null) return const SizedBox();

    final items = [
      _GridItem(
        title: "stopped_work_automatically".tr,
        value: data.stoppedWorkAutomaticallyCount.toString(),
        icon: Icons.warning_amber_rounded,
      ),
      _GridItem(
        title: "late_work_started_".tr,
        value: data.lateWorkStartedCount.toString(),
        icon: Icons.access_time,
      ),
      _GridItem(
        title: "unauthorized_leave_".tr,
        value: data.unauthorizedLeaveCount.toString(),
        icon: Icons.event_busy,
      ),
      _GridItem(
        title: "outside_working_area_".tr,
        value: data.outsideWorkingArea.toString(),
        icon: Icons.location_off,
      ),
      _GridItem(
        title: "total_worklogs".tr,
        value: data.totalWorklogs.toString(),
        icon: Icons.list_alt,
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 94,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return CardViewDashboardItem(
          padding: const EdgeInsets.fromLTRB(14, 0, 10, 0),
          child: Row(
            children: [
              Icon(item.icon, color: const Color(0xFF9C6AEF), size: 24),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryTextView(
                      text: item.title,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      textAlign: TextAlign.center,
                      color: primaryTextColorLight_(context),
                      maxLine: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    PrimaryTextView(
                      text: item.value,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      textAlign: TextAlign.center,
                      color: secondaryLightTextColor_(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GridItem {
  final String title;
  final String value;
  final IconData icon;

  _GridItem({
    required this.title,
    required this.value,
    required this.icon,
  });
}
