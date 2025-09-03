import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:belcka/res/colors.dart';

class CustomSlider extends StatelessWidget {
  CustomSlider({super.key, required this.progress, required this.onChanged});

  final RxInt progress;
  final ValueChanged<double> onChanged;

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
}
