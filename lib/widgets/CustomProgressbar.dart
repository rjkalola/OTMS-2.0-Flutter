import 'package:flutter/material.dart';
import 'package:belcka/widgets/shapes/CustomCupertinoSpinner.dart';

class CustomProgressbar extends StatelessWidget {
  const CustomProgressbar({super.key, this.radius});

  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      // child: CircularProgressIndicator(
      //   backgroundColor: Colors.white,
      //   color: defaultAccentColor_(context),
      // ),
      // child: CustomCupertinoSpinner(color: Colors.grey),
      child: CustomCupertinoSpinner(radius: radius ?? 18, color: Colors.grey),
    );
  }
}
