import 'package:flutter/material.dart';

class MapBackArrow extends StatelessWidget {
  const MapBackArrow({super.key, required this.onBackPressed});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onBackPressed,
      child: Container(
        margin: EdgeInsets.all(12),
        alignment: Alignment.center,
        width: 36,
        // Diameter of the circle
        height: 36,
        decoration: BoxDecoration(
          color: Color(0x4D000000), // Fill color of the circle
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_back_ios_new_outlined,
          size: 22,
          color: Colors.white,
        ),
      ),
    );
  }
}
