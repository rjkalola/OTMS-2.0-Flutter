import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryToTextWidget extends StatelessWidget {
  final String text;

  const DeliveryToTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 15, 6, 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TitleTextView(
            text: 'delivery_to'.tr,
            color: secondaryLightTextColor_(context),
          ),
          SizedBox(
            width: 4,
          ),
          TitleTextView(
            text: text,
            fontWeight: FontWeight.w500,
          ),
          RightArrowWidget(
            color: primaryTextColor_(context),
            size: 24,
          )
        ],
      ),
    );
  }
}
