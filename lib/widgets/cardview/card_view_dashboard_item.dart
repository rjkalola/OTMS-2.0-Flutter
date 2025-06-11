import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';

class CardViewDashboardItem extends StatelessWidget {
  const CardViewDashboardItem(
      {super.key,
      required this.child,
      this.elevation,
      this.borderRadius,
      this.borderWidth,
      this.shadowColor,
      this.borderColor,
      this.boxColor,
      this.margin});

  final Widget child;
  final double? elevation, borderRadius, borderWidth;
  final Color? shadowColor, borderColor, boxColor;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      elevation: elevation ?? 2,
      shadowColor: shadowColor ?? Colors.black54,
      color: boxColor ?? backgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 20)),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius ?? 20),
            ),
            border: Border.all(
                width: borderWidth ?? 1,
                color: borderColor ?? Colors.grey.shade200)),
        child: child,
      ),
    );
  }
}
