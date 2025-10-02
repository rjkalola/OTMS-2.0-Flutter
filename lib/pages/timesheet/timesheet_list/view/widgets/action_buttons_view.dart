import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActionButtonsView extends StatelessWidget {
  const ActionButtonsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: TitleTextView(
            text: 'lock'.tr,
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: TitleTextView(
            text: 'unlock'.tr,
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: TitleTextView(
            text: 'mark_as_paid'.tr,
          ),
        )
      ],
    );
  }
}
