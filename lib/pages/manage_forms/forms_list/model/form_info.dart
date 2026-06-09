import 'package:belcka/pages/manage_forms/forms_list/model/form_administrator.dart';
import 'package:belcka/pages/manage_forms/forms_list/model/form_created_by.dart';

class FormInfo {
  int? id;
  String? name;
  String? status;
  String? assignedTo;
  int? entries;
  int? views;
  String? createdAt;
  FormCreatedBy? createdBy;
  List<FormAdministrator>? administrators;

  FormInfo({
    this.id,
    this.name,
    this.status,
    this.assignedTo,
    this.entries,
    this.views,
    this.createdAt,
    this.createdBy,
    this.administrators,
  });

  FormInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    assignedTo = json['assigned_to'];
    entries = json['entries'];
    views = json['views'];
    createdAt = json['created_at'];
    createdBy = json['createdBy'] != null
        ? FormCreatedBy.fromJson(json['createdBy'])
        : null;
    if (json['administrators'] != null) {
      administrators = <FormAdministrator>[];
      json['administrators'].forEach((v) {
        administrators!.add(FormAdministrator.fromJson(v));
      });
    }
  }
}
