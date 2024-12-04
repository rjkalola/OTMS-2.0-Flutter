import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dashboard_controller.dart';

class HomeTabActionButtonsDotsList extends StatelessWidget {
  HomeTabActionButtonsDotsList({super.key});

  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.only(top: 4),
        height: 12,
        alignment: Alignment.center,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: List.generate(
            dashboardController.listHeaderButtons_.length,
            (position) => Container(
              margin: const EdgeInsets.all(3),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: (position ==
                        dashboardController
                            .selectedActionButtonPagerPosition.value)
                    ? Colors.blue
                    : Colors.black26,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );
    });
  }
}
