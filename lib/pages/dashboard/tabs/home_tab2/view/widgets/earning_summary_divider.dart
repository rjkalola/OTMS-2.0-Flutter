import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:belcka/res/colors.dart';

class EarningSummaryDivider extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  EarningSummaryDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 3,
      color: dividerColor_(context),
    );
  }
}
