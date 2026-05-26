import 'package:flutter/material.dart';

class AppBarBtn extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const AppBarBtn(
      {required this.icon, this.active = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: active
                  ? const Color(0xFF2563EB)
                  : const Color(0xFFE2E8F0)),
        ),
        child: Icon(icon,
            size: 17,
            color: active
                ? const Color(0xFF2563EB)
                : const Color(0xFF64748B)),
      ),
    );
  }
}