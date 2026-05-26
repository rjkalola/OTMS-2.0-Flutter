import 'package:belcka/pages/workshop/workshop_dashboard/model/workshop_dashboard_item.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkshopDashboardController extends GetxController {
  final dashboardItems = const <WorkshopDashboardItem>[
    WorkshopDashboardItem(
      title: 'Team',
      icon: Icons.group_outlined,
      iconColor: Color(0xFF31B86B),
      iconBackgroundColor: Color(0xFFEAFBF1),
      action: WorkshopDashboardAction.team,
    ),
    WorkshopDashboardItem(
      title: 'Tools hired by your team',
      icon: Icons.build_outlined,
      iconColor: Color(0xFFFF7A3D),
      iconBackgroundColor: Color(0xFFFFF0E8),
      action: WorkshopDashboardAction.hiredTools,
    ),
    WorkshopDashboardItem(
      title: 'Projects',
      icon: Icons.business_outlined,
      iconColor: Color(0xFF46C6DE),
      iconBackgroundColor: Color(0xFFEAFBFF),
      action: WorkshopDashboardAction.projects,
    ),
  ];

  void onItemTap(WorkshopDashboardItem item) {
    switch (item.action) {
      case WorkshopDashboardAction.team:
        Get.toNamed(AppRoutes.workshopTeamsScreen);
        break;
      case WorkshopDashboardAction.hiredTools:
        Get.toNamed(AppRoutes.workshopHiredToolsScreen);
        break;
      case WorkshopDashboardAction.projects:
        Get.toNamed(AppRoutes.projectListScreen);
        break;
    }
  }
}
