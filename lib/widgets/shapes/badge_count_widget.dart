import 'package:flutter/material.dart';

class CustomBadgeIcon extends StatelessWidget {
  final int count;
  final double? width, height;

  CustomBadgeIcon({
    required this.count,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width ?? 21,
      height: height ?? 21,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$count',
        style: TextStyle(
          color: Colors.white,
          fontSize: getTextSize(count),
        ),
      ),
    );
  }

  double getTextSize(int count) {
    double size = 12;
    if (count > 9) {
      size = 11;
    } else if (count > 99) {
      size = 9;
    }
    return size;
  }
}
