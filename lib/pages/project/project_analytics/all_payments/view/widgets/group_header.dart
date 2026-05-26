import 'package:belcka/pages/project/project_analytics/labor_details/model/labor_details_model.dart';
import 'package:flutter/material.dart';

class GroupHeader extends StatelessWidget {
  final String month;
  final double total;

  const GroupHeader({required this.month, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(month,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF94A3B8),
                letterSpacing: 0.5)),
        Text(fmtGbp(total),
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B))),
      ],
    );
  }
}