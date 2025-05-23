import 'package:flutter/material.dart';
import 'package:otm_inventory/widgets/shapes/CustomCupertinoSpinner.dart';

class CustomProgressbar extends StatelessWidget {
  const CustomProgressbar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      // child: CircularProgressIndicator(
      //   backgroundColor: Colors.white,
      //   color: defaultAccentColor,
      // ),
      // child: CustomCupertinoSpinner(color: Colors.grey),
      child: CustomCupertinoSpinner(radius: 18, color: Colors.grey),
    );
  }
}
