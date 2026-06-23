import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const InfoCard({
    required this.icon, required this.iconBg, required this.iconColor,
    required this.title, required this.subtitle, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: Color(0xFF1A1D2E))),
                  const SizedBox(height: 3),
                  Text(subtitle, style: TextStyle(fontSize: 12.5, color: Colors.grey.shade500, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}
