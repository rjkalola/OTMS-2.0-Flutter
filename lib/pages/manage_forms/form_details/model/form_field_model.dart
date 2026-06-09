import 'package:belcka/pages/manage_forms/form_details/model/form_field_condition.dart';

class FormFieldModel {
  String? id;
  String? type;
  String? label;
  String? description;
  bool? required;
  bool? showOnlyIf;
  bool? multipleSelection;
  bool? allowMultipleUploads;
  bool? locationStampCapture;
  bool? dateIncludeDate;
  bool? dateIncludeTime;
  List<String>? options;
  List<dynamic>? optionImages;
  dynamic minValue;
  dynamic maxValue;
  String? formulaExpression;
  String? conditionValue;
  String? conditionFieldId;
  String? conditionOperator;
  List<FormFieldCondition>? conditions;
  List<FormFieldModel>? fields;

  FormFieldModel({
    this.id,
    this.type,
    this.label,
    this.description,
    this.required,
    this.showOnlyIf,
    this.multipleSelection,
    this.allowMultipleUploads,
    this.locationStampCapture,
    this.dateIncludeDate,
    this.dateIncludeTime,
    this.options,
    this.optionImages,
    this.minValue,
    this.maxValue,
    this.formulaExpression,
    this.conditionValue,
    this.conditionFieldId,
    this.conditionOperator,
    this.conditions,
    this.fields,
  });

  FormFieldModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    label = json['label'];
    description = json['description'];
    required = json['required'];
    showOnlyIf = json['showOnlyIf'];
    multipleSelection = json['multipleSelection'];
    allowMultipleUploads = json['allowMultipleUploads'];
    locationStampCapture = json['locationStampCapture'];
    dateIncludeDate = json['dateIncludeDate'];
    dateIncludeTime = json['dateIncludeTime'];
    formulaExpression = json['formula_expression'] ?? json['formulaExpression'];
    conditionValue = json['conditionValue'];
    conditionFieldId = json['conditionFieldId'];
    conditionOperator = json['conditionOperator'];

    if (json['options'] != null) {
      options = json['options'].map<String>((v) => v.toString()).toList();
    }
    optionImages = json['option_images'] ?? json['optionImages'];

    minValue = json['min_value'] ?? json['minValue'];
    maxValue = json['max_value'] ?? json['maxValue'];

    if (json['conditions'] != null) {
      conditions = <FormFieldCondition>[];
      json['conditions'].forEach((v) {
        conditions!.add(FormFieldCondition.fromJson(v));
      });
    }

    if (json['fields'] != null) {
      fields = <FormFieldModel>[];
      json['fields'].forEach((v) {
        fields!.add(FormFieldModel.fromJson(v));
      });
    }
  }

  String get normalizedType {
    return (type ?? '').trim().toLowerCase().replaceAll('/', '');
  }

  bool get isRequired => required == true;

  bool get isHtmlLabel {
    final value = label ?? '';
    return value.contains('<') && value.contains('>');
  }
}
