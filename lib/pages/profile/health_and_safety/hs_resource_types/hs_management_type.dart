import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum HSManagementType {
  hazards,
  incidentTypes,
  threatLevels;

  // Get the display title for the screen header or buttons
  String get title {
    switch (this) {
      case HSManagementType.hazards: return "hazards";
      case HSManagementType.incidentTypes: return "incident_types";
      case HSManagementType.threatLevels: return "threat_levels";
    }
  }

  // Define the specific icon for each type as per your design
  IconData get icon {
    switch (this) {
      case HSManagementType.hazards: return Icons.warning_amber_rounded;
      case HSManagementType.incidentTypes: return Icons.error_outline_rounded;
      case HSManagementType.threatLevels: return Icons.shield_outlined;
    }
  }

  // Define the theme color for the icon
  Color get color {
    switch (this) {
      case HSManagementType.hazards: return Colors.orange;
      case HSManagementType.incidentTypes: return Colors.redAccent;
      case HSManagementType.threatLevels: return Colors.blueAccent;
    }
  }
}