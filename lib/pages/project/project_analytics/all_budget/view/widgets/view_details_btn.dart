import 'package:flutter/material.dart';

class ViewDetailsBtn extends StatelessWidget {
  final Color color;
  final VoidCallback? onTap;

  const ViewDetailsBtn({required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'View Details',
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}