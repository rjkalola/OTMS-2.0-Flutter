import 'package:belcka/widgets/liquid_glass_effect/slider/precise_slider_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CustomSlider extends StatelessWidget {
  CustomSlider({super.key, required this.progress, required this.onChanged});

  final RxInt progress;
  final ValueChanged<double> onChanged;

  /*
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CupertinoSlider(
        value: progress.value.toDouble(),
        min: 0,
        max: 100,
        activeColor: defaultAccentColor_(context),
        onChanged: onChanged,
      ),
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PreciseSlider(
        value: progress.value.toDouble(),
        onChanged: onChanged,
      ),
    );
  }
}
