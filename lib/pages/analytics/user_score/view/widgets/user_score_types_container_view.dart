import 'package:belcka/pages/analytics/user_score/controller/user_analytics_score_controller.dart';
import 'package:belcka/pages/analytics/user_score/view/widgets/user_score_types_widget.dart';
import 'package:belcka/pages/analytics/user_score/view/widgets/user_score_warning_indicator_widget.dart';
import 'package:belcka/utils/enums/order_tab_type.dart';
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
            title: 'warnings'.tr,
            valueText: '0',
            customIndicator: const UserScoreWarningIndicatorWidget(activeCount: 0),
            scoreType:UserScoreType.warnings,
          ),
          SizedBox(height: 16),

          UserScoreTypesWidget(
            title: 'kpi'.tr,
            valueText: '0%',
            progress: 0,
            progressColor: const Color(0xFF3B82F6),
            scoreType:UserScoreType.kpi,
          ),
          SizedBox(height: 16),
          UserScoreTypesWidget(
            title: 'app_activity'.tr,
            valueText:'0%',
            progress: 0,
            progressColor: const Color(0xFF7C3AED),
            scoreType:UserScoreType.appActivity
          ),
        ],
      ),
    );
  }
}
