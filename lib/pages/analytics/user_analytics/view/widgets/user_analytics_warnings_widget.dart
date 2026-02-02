import 'package:belcka/pages/analytics/user_analytics/controller/user_analytics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAnalyticsWarningsWidget extends StatelessWidget {
  UserAnalyticsWarningsWidget({super.key});

  final controller = Get.put(UserAnalyticsController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text("Warnings",
                style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500)),
            Spacer(),
            Text("0", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _warningPill(Color(0xFFFF7F00).withOpacity(0.2)),
            const SizedBox(width: 8),
            _warningPill(Color(0xFFFF7F00).withOpacity(0.2)),
            const SizedBox(width: 8),
            _warningPill(Color(0xFFFF484B).withOpacity(0.15)),
          ],
        ),
      ],
    );
  }

  Widget _warningPill(Color color) {
    return Expanded(
      child: Container(
        height: 25,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
