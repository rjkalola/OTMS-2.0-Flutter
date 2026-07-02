import 'package:belcka/pages/analytics/user_score/controller/user_analytics_score_controller.dart';
import 'package:belcka/pages/analytics/user_score/model/user_analytics_score_model.dart';
import 'package:belcka/pages/analytics/user_score/view/widgets/user_score_types_widget.dart';
import 'package:belcka/utils/enums/order_tab_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserScoreTypesContainerView extends StatelessWidget {
  UserScoreTypesContainerView({super.key});

  final controller = Get.find<UserAnalyticsScoreController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.analyticsScore.value;
      final warningsScore = data?.warningsScore ?? 0;
      final kpiScore = data?.kpiScore ?? 0;
      final appActivityScore = data?.appActivityScore ?? 0;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserScoreTypesWidget(
              title: 'warnings'.tr,
              valueText: warningsScore.asScorePercent,
              progress: 1,
              progressColor: const Color(0xFFFF7F00),
              scoreType: UserScoreType.warnings,
            ),
            const SizedBox(height: 16),
            UserScoreTypesWidget(
              title: 'kpi'.tr,
              valueText: kpiScore.asScorePercent,
              progress: 1,
              progressColor: const Color(0xFF3B82F6),
              scoreType: UserScoreType.kpi,
            ),
            const SizedBox(height: 16),
            UserScoreTypesWidget(
              title: 'app_activity'.tr,
              valueText: '${appActivityScore.asScorePercent}%',
              progress: appActivityScore / 100,
              progressColor: const Color(0xFF7C3AED),
              scoreType: UserScoreType.appActivity,
            ),
          ],
        ),
      );
    });
  }
}
