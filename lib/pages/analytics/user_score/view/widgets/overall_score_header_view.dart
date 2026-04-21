import 'package:belcka/pages/analytics/user_score/controller/user_analytics_score_controller.dart';
import 'package:belcka/pages/analytics/widgets/animated_progress_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverallScoreHeaderView extends StatelessWidget {
  OverallScoreHeaderView({super.key});

  final controller = Get.find<UserAnalyticsScoreController>();

  @override
  Widget build(BuildContext context) {
    int userScore = controller.userAnalytics.value?.score ?? 0;
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
        border: Border.all(width: 0.6, color: Colors.transparent),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('overall'.tr,
                    style: const TextStyle(fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF727272))),
                const SizedBox(height: 4),
                Text(
                  '${userScore}%',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600, color: controller.scoreTextColor(userScore)),
                ),

                const SizedBox(height: 16),
                AnimatedProgressBar(
                  value: (userScore / 100),
                  color: controller.scoreTextColor(userScore),
                  height: 14,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
