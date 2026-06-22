import 'package:belcka/pages/manage_forms/forms_list/model/form_created_by.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/publish_setting_model.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/publish_target_model.dart';

class FormDetailInfo {
  int? id;
  int? companyId;
  String? name;
  int? statusCode;
  String? statusText;
  List<FormFieldModel>? fields;
  int? createdById;
  String? assignedTo;
  String? assignUserIds;
  int? entries;
  int? views;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  FormCreatedBy? createdBy;
  List<dynamic>? formEntry;
  PublishSettingModel? publishSetting;
  PublishTargetModel? publishTarget;

  FormDetailInfo({
    this.id,
    this.companyId,
    this.name,
    this.statusCode,
    this.statusText,
    this.fields,
    this.createdById,
    this.assignedTo,
    this.assignUserIds,
    this.entries,
    this.views,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.formEntry,
    this.publishSetting,
    this.publishTarget,
  });

  FormDetailInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name']?.toString();
    createdById = json['created_by_id'];
    assignedTo = json['assigned_to']?.toString();
    assignUserIds = json['assign_user_ids']?.toString();
    entries = json['entries'];
    views = json['views'];
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
    formEntry = json['formEntry'];
    statusText = json['status_text']?.toString();

    final rawStatus = json['status'];
    if (rawStatus is int) {
      statusCode = rawStatus;
    } else if (rawStatus != null) {
      statusCode = int.tryParse(rawStatus.toString());
      statusText ??= rawStatus.toString();
    }

    createdBy = json['createdBy'] != null
        ? FormCreatedBy.fromJson(json['createdBy'])
        : null;

    publishSetting = json['publishSetting'] != null
        ? PublishSettingModel.fromJson(json['publishSetting'])
        : null;

    publishTarget = json['publish_target'] != null
        ? PublishTargetModel.fromJson(json['publish_target'])
        : null;

    fields = _parseFields(json);
  }

  List<FormFieldModel>? _parseFields(Map<String, dynamic> json) {
    final rawFields = json['fields'] ?? json['formFields'];
    if (rawFields is! List) return null;

    return rawFields
        .map((v) => FormFieldModel.fromJson(Map<String, dynamic>.from(v)))
        .toList();
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
}
