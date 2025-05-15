import 'package:flutter/material.dart';

class CustomBadgeIcon extends StatelessWidget {
  final Widget child;
  final int count;

  const CustomBadgeIcon({
    required this.child,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            right: -4,
            top: -8,
            child: Container(
              padding: EdgeInsets.all(4),
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
            ),
          ),
      ],
    );
  }

  double getTextSize(int count) {
    double size = 14;
    if (count > 9) {
      size = 11;
    } else if (count > 99) {
      size = 10;
    }
    return size;
  }
}
