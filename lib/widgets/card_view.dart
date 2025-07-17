import 'package:flutter/material.dart';

import '../res/colors.dart';
class CardView extends StatelessWidget {
  final Widget child;
  const CardView({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 3,
      shadowColor: Colors.black26,
      margin: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(6),
            ),
            border: Border.all(color: dividerColor_(context))),
        child: child,
      ),
    );
  }
}
