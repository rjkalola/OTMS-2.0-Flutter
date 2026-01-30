import 'package:belcka/pages/analytics/user_analytics/controller/user_analytics_controller.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

class UserAnalyticsScoreCard extends StatelessWidget {
  UserAnalyticsScoreCard({super.key});

  final controller = Get.put(UserAnalyticsController());

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      "Score",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      "View Details",
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                _progressRow("Warnings", 0.1, Colors.orange),
                _progressRow("KPI", 0.9, Colors.deepOrange),
                _progressRow("App activity", 0.96, Colors.lightBlue),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CircularPercentIndicator(
            radius: 60,
            lineWidth: 10,
            percent: 0.93,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Overall",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  "93%",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
            backgroundColor: Colors.grey.shade200,
            progressColor: Colors.blue,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ],
      ),
    );
  }

  Widget _progressRow(String title, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title   ${(value * 100).toInt()}%"),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              color: color,
              backgroundColor: color.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
