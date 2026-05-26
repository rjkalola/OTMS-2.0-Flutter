import 'package:flutter/material.dart';

class SmallIconBtn extends StatelessWidget {
  final IconData icon;
  const SmallIconBtn({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Icon(icon, size: 16, color: const Color(0xFF64748B)),
    );
  }
}