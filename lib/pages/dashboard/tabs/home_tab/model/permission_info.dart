class PermissionInfo {
  int? id;
  int? permissionId;
  int? userId;
  int? teamId;
  int? sequence;
  int? status;
  String? name;
  String? value;
  String? slug;
  String? icon;
  String? color;
  bool? isSequenceChanged;
  bool? isAdmin;
  bool? isApp;
  bool? isWeb;
  bool? isShow;

  PermissionInfo(
      {this.id,
      this.permissionId,
      this.userId,
      this.teamId,
      this.sequence,
      this.status,
      this.name,
      this.value,
      this.slug,
      this.icon,
      this.color,
      this.isSequenceChanged,
      this.isAdmin,
      this.isApp,
      this.isWeb,
      this.isShow});

  PermissionInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    permissionId = json['permission_id'];
    userId = json['user_id'];
    teamId = json['team_id'];
    sequence = json['sequence'];
    status = json['status'];
    name = json['name'];
    value = json['value'];
    slug = json['slug'];
    icon = json['icon'];
    color = json['color'];
    isSequenceChanged = json['isSequenceChanged'];
    isAdmin = json['is_admin'];
    isApp = json['is_app'];
    isWeb = json['is_web'];
    isShow = json['is_show'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['permission_id'] = this.permissionId;
    data['user_id'] = this.userId;
    data['team_id'] = this.teamId;
    data['sequence'] = this.sequence;
    data['status'] = this.status;
    data['name'] = this.name;
    data['value'] = this.value;
    data['slug'] = this.slug;
    data['icon'] = this.icon;
    data['color'] = this.color;
    data['isSequenceChanged'] = this.isSequenceChanged;
    data['is_admin'] = this.isAdmin;
    data['is_app'] = this.isApp;
    data['is_web'] = this.isWeb;
    data['is_show'] = this.isShow;

    return data;
  }
}
