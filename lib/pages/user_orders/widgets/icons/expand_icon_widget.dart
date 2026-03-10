import 'package:flutter/material.dart';

class ExpandIconWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const ExpandIconWidget({
    super.key,
    this.size = 22,// default size
    this.color, // default color
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.open_in_full,
      size: size,
      color: color,
    );
  }
}