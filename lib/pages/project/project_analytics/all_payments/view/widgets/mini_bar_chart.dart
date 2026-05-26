import 'package:belcka/pages/project/project_analytics/all_payments/model/payments_model.dart';
import 'package:flutter/material.dart';

class MiniBarChart extends StatelessWidget {
  final List<Payment> payments;
  const MiniBarChart({required this.payments});

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) return const SizedBox.shrink();
    final max = payments.map((p) => p.amount).reduce((a, b) => a > b ? a : b);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: payments.take(5).map((p) {
        final h = (p.amount / max) * 36;
        return Container(
          width: 6,
          height: h,
          margin: const EdgeInsets.only(left: 3),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }).toList(),
    );
  }
}