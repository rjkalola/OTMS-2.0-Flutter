import 'package:belcka/pages/project/project_analytics/labor_details/view/widgets/circular_painter.dart';
import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  final double progress;
  final String label;
  final String sublabel;

  const CircularProgress(
      {required this.progress,
        required this.label,
        required this.sublabel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      height: 62,
      child: CustomPaint(
        painter: CirclePainter(progress: progress),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            Text(sublabel,
                style: const TextStyle(
                    fontSize: 9,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}