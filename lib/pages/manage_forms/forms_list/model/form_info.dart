import 'package:belcka/pages/manage_forms/forms_list/model/form_administrator.dart';
import 'package:belcka/pages/manage_forms/forms_list/model/form_created_by.dart';

class FormInfo {
  int? id;
  int? companyId;
  String? name;
  int? statusCode;
  String? statusText;
  String? assignedTo;
  String? assignUserIds;
  int? entries;
  int? views;
  String? submittedById;
  int? createdById;
  String? createdAt;
  String? updatedAt;
  FormCreatedBy? createdBy;
  List<FormAdministrator>? administrators;

  FormInfo({
    this.id,
    this.companyId,
    this.name,
    this.statusCode,
    this.statusText,
    this.assignedTo,
    this.assignUserIds,
    this.entries,
    this.views,
    this.submittedById,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.administrators,
  });

  FormInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name']?.toString();
    assignedTo = json['assigned_to']?.toString();
    assignUserIds = json['assign_user_ids']?.toString();
    entries = json['entries'];
    views = json['views'];
    submittedById = json['submitted_by_id']?.toString();
    createdById = json['created_by_id'];
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    statusText = json['status_text']?.toString();

    final rawStatus = json['status'];
    if (rawStatus is int) {
      statusCode = rawStatus;
    } else if (rawStatus != null) {
      statusCode = int.tryParse(rawStatus.toString());
      statusText ??= rawStatus.toString();
    }

    final createdByJson = json['created_by'] ?? json['createdBy'];
    if (createdByJson is Map<String, dynamic>) {
      createdBy = FormCreatedBy.fromJson(createdByJson);
    } else if (createdByJson is Map) {
      createdBy = FormCreatedBy.fromJson(Map<String, dynamic>.from(createdByJson));
    }

    if (json['administrators'] != null) {
      administrators = <FormAdministrator>[];
      json['administrators'].forEach((v) {
        administrators!.add(FormAdministrator.fromJson(v));
      });
    }
  }

  bool get isPublished {
    final text = (statusText ?? '').toLowerCase();
    if (text.contains('publish')) return true;
    return statusCode == 2;
  }

  bool get isArchived {
    final text = (statusText ?? '').toLowerCase();
    if (text.contains('archiv')) return true;
    return statusCode == 3;
  }

  String get displayStatusLabel {
    final text = (statusText ?? '').trim();
    if (text.isNotEmpty) return text;
    return '';
  }

  bool isAssignedToUser(int userId) => _isUserInIdList(assignUserIds, userId);

  bool hasUserSubmitted(int userId) => _isUserInIdList(submittedById, userId);

  bool showPendingForUser(int userId) =>
      isAssignedToUser(userId) && !hasUserSubmitted(userId);

  bool _isUserInIdList(String? ids, int userId) {
    if (ids == null || ids.trim().isEmpty) return false;

    return ids
        .split(',')
        .map((id) => id.trim())
        .any((id) => int.tryParse(id) == userId);
  }
}
