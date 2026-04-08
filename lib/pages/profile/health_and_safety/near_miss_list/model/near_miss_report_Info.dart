import 'package:belcka/pages/profile/health_and_safety/near_miss_list/model/report_file_info.dart';

class NearMissReportInfo {
  final int id;
  final int companyId;
  final String companyName;
  final int hazardId;
  final String hazardName;
  final String description;
  final int addedBy;
  final String addedByUserName;
  final String addedByUserImage;
  final String addedByUserThumbImage;
  final List<ReportFileInfo> files;

  NearMissReportInfo({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.hazardId,
    required this.hazardName,
    required this.description,
    required this.addedBy,
    required this.addedByUserName,
    required this.addedByUserImage,
    required this.addedByUserThumbImage,
    required this.files,
  });

  // Helper to check if any files exist
  bool get hasAttachments => files.isNotEmpty;

  factory NearMissReportInfo.fromJson(Map<String, dynamic> json) {
    return NearMissReportInfo(
      id: json['id'] ?? 0,
      companyId: json['company_id'] ?? 0,
      companyName: json['company_name'] ?? '',
      hazardId: json['hazard_id'] ?? 0,
      hazardName: json['hazard_name'] ?? '',
      description: json['description'] ?? '',
      addedBy: json['added_by'] ?? 0,
      addedByUserName: json['added_by_user_name'] ?? '',
      addedByUserImage: json['added_by_user_image'] ?? '',
      addedByUserThumbImage: json['added_by_user_thumb_image'] ?? '',
      files: (json['files'] as List?)
          ?.map((f) => ReportFileInfo.fromJson(f))
          .toList() ?? [],
    );
  }
}