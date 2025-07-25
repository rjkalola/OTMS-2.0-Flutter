import 'package:otm_inventory/pages/project/project_info/model/project_info.dart';

class ProjectDetailsApiResponse {
  final bool isSuccess;
  final String message;
  final ProjectInfo? info;

  ProjectDetailsApiResponse({
    required this.isSuccess,
    required this.message,
    required this.info,
  });

  factory ProjectDetailsApiResponse.fromJson(Map<String, dynamic> json) {
    return ProjectDetailsApiResponse(
      isSuccess: json["IsSuccess"] ?? false,
      message: json["message"] ?? "",
      info: json["info"] != null ? ProjectInfo.fromJson(json["info"]) : null,
    );
  }
}