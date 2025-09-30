import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';

class GradientProgressBar extends StatelessWidget {
  final double progress; // value between 0.0 - 1.0

  const GradientProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Container(
            height: 20,
            color: lightGreyColor(context),
          ),
          FractionallySizedBox(
            widthFactor: progress, // controls fill
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.red, Colors.orange, Colors.yellow, Colors.green],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
