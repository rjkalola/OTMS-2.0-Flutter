import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/hs_resource_types_info.dart';

class HealthAndSafetyResourceResponse {
  final bool isSuccess;
  final String message;
  final List<HSResourceTypesInfo> users;
  final List<HSResourceTypesInfo> teams;
  final List<HSResourceTypesInfo> hazards;
  final List<HSResourceTypesInfo> incidentTypes;
  final List<HSResourceTypesInfo> threatLevels;

  HealthAndSafetyResourceResponse({
    required this.isSuccess,
    required this.message,
    required this.users,
    required this.teams,
    required this.hazards,
    required this.incidentTypes,
    required this.threatLevels,
  });

  factory HealthAndSafetyResourceResponse.fromJson(Map<String, dynamic> json) {
    return HealthAndSafetyResourceResponse(
      isSuccess: json['IsSuccess'] ?? false,
      message: json['message'] ?? '',
      users: (json['users'] as List?)?.map((i) => HSResourceTypesInfo.fromJson(i)).toList() ?? [],
      teams: (json['teams'] as List?)?.map((i) => HSResourceTypesInfo.fromJson(i)).toList() ?? [],
      hazards: (json['hazards'] as List?)?.map((i) => HSResourceTypesInfo.fromJson(i)).toList() ?? [],
      incidentTypes: (json['incident_types'] as List?)?.map((i) => HSResourceTypesInfo.fromJson(i)).toList() ?? [],
      threatLevels: (json['threat_levels'] as List?)?.map((i) => HSResourceTypesInfo.fromJson(i)).toList() ?? [],

    );
  }
}
