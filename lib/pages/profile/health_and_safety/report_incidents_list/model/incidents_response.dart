import 'package:belcka/pages/profile/health_and_safety/report_incidents_list/model/incident_report_info.dart';

class IncidentsResponse {
  final bool isSuccess;
  final String message;
  final List<IncidentReportInfo> info;

  IncidentsResponse({
    required this.isSuccess,
    required this.message,
    required this.info,
  });

  factory IncidentsResponse.fromJson(Map<String, dynamic> json) {
    return IncidentsResponse(
      isSuccess: json['IsSuccess'] ?? false,
      message: json['message'] ?? '',
      info: (json['info'] as List?)
          ?.map((i) => IncidentReportInfo.fromJson(i))
          .toList() ?? [],
    );
  }
}

