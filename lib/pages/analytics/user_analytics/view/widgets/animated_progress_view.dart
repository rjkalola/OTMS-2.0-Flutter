import 'package:flutter/material.dart';

class AnimatedProgressRow extends StatelessWidget {
  final String title;
  final double value;
  final Color color;
  final AnimationController controller;

  const AnimatedProgressRow({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500)),
            const Spacer(),
            Text("${(value * 100).round()}%",
                style:TextStyle(fontSize: 15,fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 10),
        AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: controller.value * value,
                minHeight: 20,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            );
          },
        ),
      ],
    );
  }
}