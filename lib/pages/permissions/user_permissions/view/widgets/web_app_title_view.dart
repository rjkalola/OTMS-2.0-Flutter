import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebAppTitleView extends StatelessWidget {
  const WebAppTitleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 50,
          child: PrimaryTextView(
            textAlign: TextAlign.center,
            text: 'web'.tr,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          width: 12,
        ),
        SizedBox(
          width: 50,
          child: PrimaryTextView(
            textAlign: TextAlign.center,
            text: 'app'.tr,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
