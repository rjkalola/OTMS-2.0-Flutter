import 'package:belcka/pages/analytics/user_analytics/controller/user_analytics_controller.dart';
import 'package:belcka/pages/analytics/user_analytics/view/widgets/animated_overall_progress.dart';
import 'package:belcka/pages/analytics/user_analytics/view/widgets/animated_progress_view.dart';
import 'package:belcka/pages/analytics/user_analytics/view/widgets/user_analytics_warnings_widget.dart';
import 'package:belcka/res/theme/app_colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAnalyticsScoreCard extends StatefulWidget {
  const UserAnalyticsScoreCard({super.key});

  @override
  State<UserAnalyticsScoreCard> createState() => _UserAnalyticsScoreCardState();
}

class _UserAnalyticsScoreCardState extends State<UserAnalyticsScoreCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final controller = Get.put(UserAnalyticsController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: CardViewDashboardItem(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 24),
                    UserAnalyticsWarningsWidget(),
                    const SizedBox(height: 8),
                    AnimatedProgressRow(
                      controller: _controller,
                      title: "KPI",
                      value: 0.9,
                      color: Color(0xFFFF9466),
                    ),
                    const SizedBox(height: 20),
                    AnimatedProgressRow(
                      controller: _controller,
                      title: "App activity",
                      value: 0.96,
                      color: Color(0xFF3DB9FF),
                    ),
                  ],
                ),
              ),

              const SizedBox(width:20),
              //Overall
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF007AFF).withOpacity(0.15),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      "View Details",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: AppColors.defaultAccentColor,
                      fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedOverallProgress(percentage: 100),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Score",
          style: TextStyle(fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
