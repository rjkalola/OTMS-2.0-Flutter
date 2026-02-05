import 'package:belcka/pages/analytics/user_score/controller/user_analytics_score_controller.dart';
import 'package:belcka/pages/analytics/widgets/animated_progress_bar.dart';
import 'package:belcka/res/theme/app_colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserScoreTypesWidget extends StatelessWidget {
  final String title;
  final String valueText;
  final String? scoreType;

  /// For KPI & App Activity
  final double? progress;
  final Color? progressColor;

  /// For Warnings
  final Widget? customIndicator;

  const UserScoreTypesWidget({
    super.key,
    required this.title,
    required this.valueText,
    this.progress,
    this.progressColor,
    this.customIndicator,
    this.scoreType
  });

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Spacer(),
              _viewDetails(scoreType ?? ""),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                valueText,
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold),
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

  Widget _viewDetails(String scoreType) {
    final controller = Get.put(UserAnalyticsScoreController());

    return TextButton(
      onPressed: () {
        var arguments = {
          AppConstants.intentKey.userId: controller.userId,
        };
        controller.moveToScreen(AppRoutes.userScoreTypesScreen, arguments, scoreType);
      },
      style: TextButton.styleFrom(
        backgroundColor: Color(0xFF007AFF).withOpacity(0.15),
        shape: const StadiumBorder(),
      ),
      child: const Text(
        "View Details",
        style: TextStyle(fontWeight: FontWeight.bold,
            color: AppColors.defaultAccentColor,
            fontSize: 13),
      ),
    );
  }
}