import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';

class RightArrowWidget extends StatelessWidget {
  const RightArrowWidget({super.key, this.size, this.color});

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.keyboard_arrow_right,
      size: size ?? 26,
      color: color ?? Colors.grey,
    );
  }
}
