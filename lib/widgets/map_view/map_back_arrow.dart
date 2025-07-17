import 'package:flutter/material.dart';

class MapBackArrow extends StatelessWidget {
  const MapBackArrow({super.key, required this.onBackPressed});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onBackPressed,
        icon: Icon(
          Icons.arrow_back_ios_new_outlined,
          size: 26,
        ));
  }
}
