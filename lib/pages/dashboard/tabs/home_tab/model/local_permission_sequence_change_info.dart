class LocalPermissionSequenceChangeInfo {
  int? permissionId;
  int? newPosition;

  LocalPermissionSequenceChangeInfo({
    this.permissionId,
    this.newPosition,
  });

  LocalPermissionSequenceChangeInfo.fromJson(Map<String, dynamic> json) {
    permissionId = json['permission_id'];
    newPosition = json['new_position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['permission_id'] = this.permissionId;
    data['new_position'] = this.newPosition;
    return data;
  }
}
