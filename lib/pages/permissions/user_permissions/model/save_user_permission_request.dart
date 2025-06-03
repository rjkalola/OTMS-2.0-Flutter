class SaveUserPermissionRequest {
  int? permissionId;
  int? status;

  SaveUserPermissionRequest({
    this.permissionId,
    this.status,
  });

  SaveUserPermissionRequest.fromJson(Map<String, dynamic> json) {
    permissionId = json['permission_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['permission_id'] = this.permissionId;
    data['status'] = this.status;
    return data;
  }
}
