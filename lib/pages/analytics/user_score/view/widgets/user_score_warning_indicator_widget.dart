import 'package:flutter/material.dart';

class UserScoreWarningIndicatorWidget extends StatelessWidget {
  final int activeCount; // how many warnings (0–3)

  const UserScoreWarningIndicatorWidget({super.key, required this.activeCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == 2 ? 0 : 8),
            child: _warningPill(
              color: _colors[index],
              active: index < activeCount,
            ),
          ),
        );
      }),
    );
  }

  static const _colors = [
    Color(0xFFFF7F00), // orange
    Color(0xFFFF7F00), // light orange
    Color(0xFFFF484B), // pink
  ];

  Widget _warningPill({
    required Color color,
    required bool active,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: active ? 1 : 0.15),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Container(
          height: 8,
          decoration: BoxDecoration(
            color: color.withOpacity(value),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }
}