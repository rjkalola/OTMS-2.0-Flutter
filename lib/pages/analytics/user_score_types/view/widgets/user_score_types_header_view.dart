import 'package:belcka/pages/analytics/user_score/view/widgets/user_score_warning_indicator_widget.dart';
import 'package:belcka/pages/analytics/user_score_types/controller/user_score_types_controller.dart';
import 'package:belcka/pages/analytics/user_score_types/view/widgets/user_score_types_header.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserScoreTypesHeaderView extends StatelessWidget {
  UserScoreTypesHeaderView({super.key});

  final controller = Get.put(UserScoreTypesController());

  @override
  Widget build(BuildContext context) {
    int userScore = controller.userAnalytics.value?.score ?? 0;
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
        border: Border.all(width: 0.6, color: Colors.transparent),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: Column(
        children: [

          UserScoreTypesHeader(valueText: "1",
            customIndicator: UserScoreWarningIndicatorWidget(activeCount: 1),
            dateRange: controller.dateRange.value ?? "",),

        /*
          UserScoreTypesHeader(
            valueText: '90%',
            progress: 0.9,
            progressColor: const Color(0xFF3B82F6),
            scoreType:"kpi",
          ),
          */

        /*
          UserScoreTypesHeader(
            valueText: '96%',
            progress: 0.96,
            progressColor: const Color(0xFF7C3AED),
            scoreType: "app_activity",
          ),
          */

        ],
      ),
    );
  }
}
