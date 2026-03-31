import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/liquid_glass_effect/slider/precise_slider_widget.dart';
// import 'package:cupertino_native/components/slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSlider extends StatelessWidget {
  CustomSlider({
    super.key,
    required this.progress,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
  });

  final RxInt progress;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CupertinoSlider(
        value: progress.value.toDouble().clamp(min, max),
        min: min,
        max: max,
        activeColor: defaultAccentColor_(context),
        onChanged: onChanged,
      ),
    );
  }

 /* @override
  Widget build(BuildContext context) {
    if (AppUtils().isDeviceSupportsLiquidGlass()){
      return Obx(
            () => Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: CNSlider(
                min: 0.0,
                max: 100.0,
                color: Colors.blueAccent,
                value: progress.value.toDouble(),
                onChanged: onChanged,
              ),
            ),
      );
    }
    else{
      return Obx(
            () => PreciseSlider(
          value: progress.value.toDouble(),
          onChanged: onChanged,
        ),
      );
    }
  }*/
}
