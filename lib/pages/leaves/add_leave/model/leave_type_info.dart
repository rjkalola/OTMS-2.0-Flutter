class LeaveTypeInfo {
  int? id;
  String? name;
  String? type;
  int? companyId;
  String? companyName;

  LeaveTypeInfo({this.id, this.name, this.type, this.companyId, this.companyName});

  LeaveTypeInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    companyId = json['company_id'];
    companyName = json['company_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    return data;
  }
}