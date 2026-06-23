import 'package:flutter/material.dart';

class GlassBackButton extends StatelessWidget {
  final VoidCallback onTap;
  const GlassBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: const Icon(Icons.chevron_left, color: Color(0xFF555770), size: 24),
      ),
    );
  }
}