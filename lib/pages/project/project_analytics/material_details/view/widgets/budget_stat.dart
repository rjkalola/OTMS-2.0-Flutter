import 'package:flutter/material.dart';

class BudgetStat extends StatelessWidget {
  final String label;
  final String value;
  final Color dotColor;
  final bool alignRight;
  const BudgetStat({required this.label, required this.value, required this.dotColor, this.alignRight = false});

  @override
  Widget build(BuildContext context) {
    final dot = Container(width: 7, height: 7, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle));
    final labelW = Text(label, style: const TextStyle(fontSize: 10, color: Colors.white60, fontWeight: FontWeight.w500));
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: alignRight ? [labelW, const SizedBox(width: 5), dot] : [dot, const SizedBox(width: 5), labelW],
        ),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700)),
      ],
    );
  }
}