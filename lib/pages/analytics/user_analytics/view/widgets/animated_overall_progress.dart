import 'package:belcka/pages/analytics/user_analytics/view/widgets/static_overall_painter.dart';
import 'package:flutter/material.dart';

class AnimatedOverallProgress extends StatelessWidget {
  final int percentage;

  const AnimatedOverallProgress({
    super.key,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:160,
      height: 160,
      child: CustomPaint(
        painter: StaticOverallPainter(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Overall", style:
              TextStyle(color: Colors.blueGrey,
                  fontSize: 17,
                  fontWeight: FontWeight.w500)),
              Text("$percentage%",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textColor(percentage),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Color _textColor(int value) {
    if (value < 25) return Color(0xFFF26B4D);
    if (value < 50) return Color(0xFF576F8F);
    if (value < 75) return Color(0xFF0956CA);
    return Color(0xFF65BB64);
  }
}