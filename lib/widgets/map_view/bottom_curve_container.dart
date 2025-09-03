import 'package:flutter/material.dart';
import 'package:belcka/res/colors.dart';

class BottomCurveContainer extends StatelessWidget {
  const BottomCurveContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 15,
        width: double.infinity,
        decoration: BoxDecoration(
            color: dashBoardBgColor_(context),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      ),
    );
  }
}
