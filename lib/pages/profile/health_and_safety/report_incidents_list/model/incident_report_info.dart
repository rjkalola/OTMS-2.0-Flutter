import 'package:belcka/pages/profile/health_and_safety/near_miss_list/model/report_file_info.dart';

class IncidentReportInfo{
  final int id;
  final int companyId;
  final String companyName;
  final int incidentTypeId;
  final int threatLevelId;
  final int notifyTo;
  final String incidentType;
  final String threatLevel;
  final String date;
  final int userId;
  final String userName;
  final String userImage;
  final String userThumbImage;
  final String title;
  final List<ReportFileInfo> files;

  IncidentReportInfo({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.incidentTypeId,
    required this.threatLevelId,
    required this.notifyTo,
    required this.incidentType,
    required this.threatLevel,
    required this.date,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.userThumbImage,
    required this.title,
    required this.files,
  });

  bool get hasAttachments => files.isNotEmpty;

  factory IncidentReportInfo.fromJson(Map<String, dynamic> json) {
    return IncidentReportInfo(
      id: json['id'] ?? 0,
      companyId: json['company_id'] ?? 0,
      companyName: json['company_name'] ?? '',
      incidentTypeId: json['incident_type_id'] ?? 0,
      threatLevelId: json['threat_level_id'] ?? 0,
      notifyTo: json['notify_to'] ?? 0,
      incidentType: json['incident_type'] ?? '',
      threatLevel: json['threat_level'] ?? '',
      date: json['date'] ?? '',
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? '',
      userImage: json['user_image'] ?? '',
      userThumbImage: json['user_thumb_image'] ?? '',
      title: json['title'] ?? '',
      files: (json['files'] as List?)
          ?.map((f) => ReportFileInfo.fromJson(f))
          .toList() ?? [],
    );
  }
}