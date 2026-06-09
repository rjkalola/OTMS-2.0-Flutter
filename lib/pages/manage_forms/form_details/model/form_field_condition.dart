class FormFieldCondition {
  String? fieldId;
  String? joinWith;
  String? operator;

  FormFieldCondition({this.fieldId, this.joinWith, this.operator});

  FormFieldCondition.fromJson(Map<String, dynamic> json) {
    fieldId = json['fieldId'];
    joinWith = json['joinWith'];
    operator = json['operator'];
  }
}
