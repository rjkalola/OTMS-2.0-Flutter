import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';

class SaveButtonDetailsOfWork extends StatelessWidget {
  const SaveButtonDetailsOfWork({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: SizedBox(
        width: double.infinity,
        child: PrimaryBorderButton(
            buttonText: 'save'.tr,
            onPressed: () {},
            fontColor: defaultAccentColor,
            borderColor: defaultAccentColor),
      ),
    );
  }
}
