import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/controller/home_tab_controller.dart';

class HomeTabActionButtonsDotsList extends StatelessWidget {
  HomeTabActionButtonsDotsList({super.key});

  final controller = Get.put(HomeTabController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.only(top: 4,bottom: 12),
        height: 12,
        alignment: Alignment.center,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: List.generate(
            controller.listHeaderButtons_.length,
            (position) => Container(
              margin: const EdgeInsets.all(3),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: (position ==
                        controller
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
