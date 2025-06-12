class PermissionInfo {
  int? id;
  int? permissionId;
  int? userId;
  int? sequence;
  bool? status;
  String? name;
  String? value;
  String? slug;
  String? icon;
  String? color;
  bool? isSequenceChanged;
  bool? isAdmin;

  PermissionInfo(
      {this.id,
      this.permissionId,
      this.userId,
      this.sequence,
      this.status,
      this.name,
      this.value,
      this.slug,
      this.icon,
      this.color,
      this.isSequenceChanged,
      this.isAdmin});

  PermissionInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    permissionId = json['permission_id'];
    userId = json['user_id'];
    sequence = json['sequence'];
    status = json['status'];
    name = json['name'];
    value = json['value'];
    slug = json['slug'];
    icon = json['icon'];
    color = json['color'];
    isSequenceChanged = json['isSequenceChanged'];
    isAdmin = json['is_admin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['permission_id'] = this.permissionId;
    data['user_id'] = this.userId;
    data['sequence'] = this.sequence;
    data['status'] = this.status;
    data['name'] = this.name;
    data['value'] = this.value;
    data['slug'] = this.slug;
    data['icon'] = this.icon;
    data['color'] = this.color;
    data['isSequenceChanged'] = this.isSequenceChanged;
    data['is_admin'] = this.isAdmin;
    return data;
  }
}
