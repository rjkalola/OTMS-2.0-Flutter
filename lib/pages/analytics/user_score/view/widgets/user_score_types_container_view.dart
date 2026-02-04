import 'package:belcka/pages/analytics/user_score/controller/user_analytics_score_controller.dart';
import 'package:belcka/pages/analytics/user_score/view/widgets/user_score_types_widget.dart';
import 'package:belcka/pages/analytics/user_score/view/widgets/user_score_warning_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserScoreTypesContainerView extends StatelessWidget {
  UserScoreTypesContainerView({super.key});

  final controller = Get.put(UserAnalyticsScoreController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserScoreTypesWidget(
            title: 'Warnings',
            valueText: '1',
            customIndicator: const UserScoreWarningIndicatorWidget(activeCount: 1),
            scoreType: "warnings",
          ),
          SizedBox(height: 16),

          UserScoreTypesWidget(
            title: 'KPI',
            valueText: '90%',
            progress: 0.9,
            progressColor: const Color(0xFF3B82F6),
            scoreType:"kpi",
          ),
          SizedBox(height: 16),
          UserScoreTypesWidget(
            title: 'App activity',
            valueText: '96%',
            progress: 0.96,
            progressColor: const Color(0xFF7C3AED),
            scoreType: "app_activity",
          ),
        ],
      ),
    );
  }
}
