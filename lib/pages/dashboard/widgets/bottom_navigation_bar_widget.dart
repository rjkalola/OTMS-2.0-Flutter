import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/drawable.dart';

import '../../../res/colors.dart';
import '../dashboard_controller.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  BottomNavigationBarWidget({super.key});

  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return BottomNavigationBar(
        elevation: 0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(Drawable.activeHomeTabIcon, width: 30),
              icon: SvgPicture.asset(Drawable.inactiveHomeTabIcon, width: 30),
              label: ''),
          // BottomNavigationBarItem(
          //     activeIcon: Image.asset(Drawable.activeProfileTabIcon, width: 26),
          //     icon: Image.asset(Drawable.inactiveProfileTabIcon, width: 26),
          //     label: ''),
          BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(Drawable.activeMoreTabIcon, width: 30),
              icon: SvgPicture.asset(Drawable.inactiveMoreTabIcon, width: 30),
              label: ''),
        ],
        currentIndex: dashboardController.selectedIndex.value,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        backgroundColor: bottomTabBackgroundColor,
        onTap: dashboardController.onItemTapped,
      );
    }) ;
  }
}
