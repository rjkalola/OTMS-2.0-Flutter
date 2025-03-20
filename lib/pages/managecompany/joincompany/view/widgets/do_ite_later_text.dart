import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class DoItLater extends StatelessWidget {
  const DoItLater({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PrimaryTextView(
        text: 'do_it_later'.tr.toUpperCase(),
        color: defaultAccentColor,
        fontSize: 16,
      ),
    );
  }
}
