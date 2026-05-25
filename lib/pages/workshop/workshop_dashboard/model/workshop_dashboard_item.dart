import 'package:flutter/material.dart';

enum WorkshopDashboardAction {
  team,
  hiredTools,
  projects,
}

class WorkshopDashboardItem {
  const WorkshopDashboardItem({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.action,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final WorkshopDashboardAction action;
}
