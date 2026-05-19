import 'package:flutter/material.dart';

class PillBadge extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const PillBadge({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFBFDBFE), width: 1),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2563EB),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}