import 'package:flutter/material.dart';

class BudgetLegend extends StatelessWidget {
  final Color dot;
  final String label;
  final String value;
  final bool alignRight;

  const BudgetLegend({
    required this.dot,
    required this.label,
    required this.value,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: alignRight
              ? [
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white60,
                    fontWeight: FontWeight.w500)),
            const SizedBox(width: 5),
            Container(
                width: 7,
                height: 7,
                decoration:
                BoxDecoration(color: dot, shape: BoxShape.circle)),
          ]
              : [
            Container(
                width: 7,
                height: 7,
                decoration:
                BoxDecoration(color: dot, shape: BoxShape.circle)),
            const SizedBox(width: 5),
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white60,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w700)),
      ],
    );
  }
}