import 'package:belcka/pages/project/project_analytics/analytics/model/project_analytics_model.dart';
import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';

class BudgetRow extends StatelessWidget {
  final BudgetItem item;
  final String currencySymbol;
  const BudgetRow({required this.item, this.currencySymbol = "£"});

  @override
  Widget build(BuildContext context) {
    final progress = (item.spent / item.amount).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.label,
                style:  TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: primaryTextColor_(context))),
            Text(
              '£${_fmtShort(item.amount)}',
              style:  TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: primaryTextColor_(context)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: item.color.withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        if (item.overspent)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                const Icon(Icons.warning_rounded, size: 10, color: Color(0xFFF97316)),
                const SizedBox(width: 3),
                Text(
                  'Overspending  +£${_fmtShort(item.overspentBy!)}',
                  style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFF97316),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _fmtShort(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)},000';
    return v.toStringAsFixed(0);
  }
}