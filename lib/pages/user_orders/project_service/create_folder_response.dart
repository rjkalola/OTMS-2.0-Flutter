import 'dart:convert';

class CreateFolderResponse {
  final bool isSuccess;
  final String message;
  final CreatedFolder? info;

  CreateFolderResponse({
    required this.isSuccess,
    required this.message,
    this.info,
  });

  factory CreateFolderResponse.fromJson(Map<String, dynamic> json) {
    return CreateFolderResponse(
      isSuccess: json['IsSuccess'] ?? false,
      message: json['message'] ?? '',
      // Map the single object in 'info'
      info: json['info'] != null ? CreatedFolder.fromJson(json['info']) : null,
    );
  }
}

class CreatedFolder {
  final int id;
  final int companyId;
  final int? projectId;
  final String name;
  final String? createdAt;
  final String? updatedAt;

  CreatedFolder({
    required this.id,
    required this.companyId,
    this.projectId,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory CreatedFolder.fromJson(Map<String, dynamic> json) {
    return CreatedFolder(
      id: json['id'] ?? 0,
      companyId: json['company_id'] ?? 0,
      projectId: json['project_id'],
      name: json['name'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}