import 'package:flutter/material.dart';

import '../res/colors.dart';

class CustomProgressbar extends StatelessWidget {
  const CustomProgressbar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        color: defaultAccentColor,
      ),
    );
  }
}
