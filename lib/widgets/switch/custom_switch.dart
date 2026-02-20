import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/liquid_glass_effect/switch/precise_toggle_widget.dart';
import 'package:flutter/cupertino.dart';
// import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final ValueChanged<bool>? onValueChange;
  final mValue;
  final Color? activeColor, activeCircleColor;
  final bool? isDisable;

  const CustomSwitch(
      {super.key,
      required this.onValueChange,
      required this.mValue,
      this.activeColor = Colors.blueAccent,
      this.activeCircleColor,
      this.isDisable});

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      // activeColor: activeCircleColor ?? Colors.white,
      activeTrackColor: activeColor ?? Colors.green,
      value: mValue,
      onChanged: !(isDisable ?? false)
          ? (value) {
              onValueChange!(value);
            }
          : null,
    );
  }

 /* @override
  Widget build(BuildContext context) {
    if (AppUtils().isDeviceSupportsLiquidGlass()){
      return CNSwitch(
        value: mValue,
        color: activeColor,
        onChanged:(value) {
          if (isDisable == true) {
            null;
          } else {
            onValueChange!(value);
          }
        },
      );
    }
    else{
      return PreciseToggle(
        value: mValue,
        onChanged: (value) {
          if (isDisable == true) {
            null;
          } else {
            onValueChange!(value);
          }
        },
        activeColor: activeColor,
        activeCircleColor: activeCircleColor,
      );
    }
  }*/
}
