import 'package:flutter/material.dart';

class ExpandedStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const ExpandedStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: color)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}