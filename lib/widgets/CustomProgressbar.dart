import 'package:flutter/material.dart';
import 'package:otm_inventory/widgets/shapes/CustomCupertinoSpinner.dart';

class CustomProgressbar extends StatelessWidget {
  const CustomProgressbar({super.key, this.radius});

  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      // child: CircularProgressIndicator(
      //   backgroundColor: Colors.white,
      //   color: defaultAccentColor,
      // ),
      // child: CustomCupertinoSpinner(color: Colors.grey),
      child: CustomCupertinoSpinner(radius: radius ?? 18, color: Colors.grey),
    );
  }
}
