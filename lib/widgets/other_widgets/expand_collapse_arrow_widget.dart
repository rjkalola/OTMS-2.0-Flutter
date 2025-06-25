import 'package:flutter/material.dart';

class ExpandCollapseArrowWidget extends StatelessWidget {
  const ExpandCollapseArrowWidget({super.key, required this.isOpen, this.size});

  final bool isOpen;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return isOpen
        ? Icon(
            Icons.keyboard_arrow_up_outlined,
            size: size ?? 26,
          )
        : Icon(
            Icons.keyboard_arrow_down_outlined,
            size: size ?? 26,
          );
  }
}
