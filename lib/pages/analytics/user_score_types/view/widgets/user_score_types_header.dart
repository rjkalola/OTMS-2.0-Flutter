import 'package:belcka/pages/analytics/widgets/animated_progress_bar.dart';
import 'package:flutter/material.dart';

class UserScoreTypesHeader extends StatelessWidget {
  final String valueText;
  final String? scoreType;
  final String? dateRange;
  /// For KPI & App Activity
  final double? progress;
  final Color? progressColor;
  /// For Warnings
  final Widget? customIndicator;

  const UserScoreTypesHeader({
    super.key,
    required this.valueText,
    this.progress,
    this.progressColor,
    this.customIndicator,
    this.scoreType,
    this.dateRange
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          SizedBox(height: 16,),
          DateRangeView(dateRange: dateRange ?? "",)
        ],
      ),
    );
  }
}

class DateRangeView extends StatelessWidget {
  final String dateRange;
  const DateRangeView({
    super.key,
    required this.dateRange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 25,
          ),
          const SizedBox(width: 10),
          Text(
            dateRange,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}