import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';

class OrderQuantityDisplayTextView extends StatelessWidget {
  final int value;
  final double? width;
  final double? height;
  final double? borderRadius;

  const OrderQuantityDisplayTextView({
    super.key,
    required this.value,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 52,
      height: height ?? 32,
      alignment: Alignment.center,
      decoration: AppUtils.getGrayBorderDecoration(
          borderColor: normalTextFieldBorderColor_(context),
          radius: borderRadius ?? 6),
      child: PrimaryTextView(
        text: value.toString(),
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
