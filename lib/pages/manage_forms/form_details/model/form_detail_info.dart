import 'package:belcka/pages/manage_forms/forms_list/model/form_created_by.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_model.dart';

class FormDetailInfo {
  int? id;
  String? name;
  String? status;
  List<FormFieldModel>? fields;
  int? createdById;
  String? assignedTo;
  int? entries;
  int? views;
  String? createdAt;
  String? updatedAt;
  FormCreatedBy? createdBy;
  List<dynamic>? formEntry;

  FormDetailInfo({
    this.id,
    this.name,
    this.status,
    this.fields,
    this.createdById,
    this.assignedTo,
    this.entries,
    this.views,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.formEntry,
  });

  FormDetailInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdById = json['created_by_id'];
    assignedTo = json['assigned_to'];
    entries = json['entries'];
    views = json['views'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    formEntry = json['formEntry'];

    createdBy = json['createdBy'] != null
        ? FormCreatedBy.fromJson(json['createdBy'])
        : null;

    if (json['fields'] != null) {
      fields = <FormFieldModel>[];
      json['fields'].forEach((v) {
        fields!.add(FormFieldModel.fromJson(v));
      });
    }
  }
}
