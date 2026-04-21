import 'package:belcka/pages/analytics/widgets/animated_progress_bar.dart';
import 'package:flutter/material.dart';

class AppActivityAnalyticsHeader extends StatelessWidget {
  const AppActivityAnalyticsHeader({
    super.key,
    required this.valueText,
    required this.progress,
    required this.dateRange,
  });

  final String valueText;
  final double progress;
  final String dateRange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          AnimatedProgressBar(
            value: progress,
            color: const Color(0xFF7C3AED),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_month_outlined, size: 20),
              const SizedBox(width: 10),
              Text(
                dateRange,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
