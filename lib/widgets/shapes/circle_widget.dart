import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  const CircleWidget(
      {super.key,
      required this.color,
      required this.width,
      required this.height});

  final Color color;
  final double width, height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
