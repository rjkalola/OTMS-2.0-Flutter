import 'package:belcka/pages/analytics/user_score/controller/user_analytics_score_controller.dart';
import 'package:belcka/pages/analytics/widgets/animated_progress_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/enums/order_tab_type.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserScoreTypesWidget extends StatelessWidget {
  final controller = Get.find<UserAnalyticsScoreController>();

  final String title;
  final String valueText;
  final UserScoreType? scoreType;

  /// For KPI & App Activity
  final double? progress;
  final Color? progressColor;

  /// For Warnings
  final Widget? customIndicator;

  UserScoreTypesWidget(
      {super.key,
      required this.title,
      required this.valueText,
      this.progress,
      this.progressColor,
      this.customIndicator,
      this.scoreType});

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              const Spacer(),
              PrimaryButton(
                  isFixSize: true,
                  width: 120,
                  height: 32,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  buttonText: 'view_details'.tr,
                  color: const Color(0xFF007AFF).withValues(alpha: 0.15),
                  fontColor: defaultAccentColor_(Get.context!),
                  onPressed: () {
                    final arguments = {
                      AppConstants.intentKey.userId: controller.userId,
                      "score_type": scoreType,
                    };
                    final route = _detailsRouteByScoreType(scoreType);
                    controller.moveToScreen(
                      route,
                      arguments,
                    );
                  })
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                valueText,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (customIndicator != null)
            customIndicator!
          else if (progress != null)
            AnimatedProgressBar(
              value: progress!,
              color: progressColor ?? Colors.blue,
            ),
        ],
      ),
    );
  }

  String _detailsRouteByScoreType(UserScoreType? type) {
    switch (type) {
      case UserScoreType.kpi:
        return AppRoutes.kpiScoreScreen;
      case UserScoreType.appActivity:
        return AppRoutes.appActivityScoreScreen;
      case UserScoreType.warnings:
      default:
        return AppRoutes.warningsScoreScreen;
    }
  }
}
