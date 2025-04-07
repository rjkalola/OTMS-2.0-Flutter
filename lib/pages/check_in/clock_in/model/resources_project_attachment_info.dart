class ResourcesProjectAttachmentInfo {
  int? id;
  int? pwProjectId;
  String? name;
  String? extension;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? path;
  String? destination;
  String? originalPath;

  ResourcesProjectAttachmentInfo(
      {this.id,
      this.pwProjectId,
      this.name,
      this.extension,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.path,
      this.destination,
      this.originalPath});

  ResourcesProjectAttachmentInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pwProjectId = json['pw_project_id'];
    name = json['name'];
    extension = json['extension'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    path = json['path'];
    destination = json['destination'];
    originalPath = json['original_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pw_project_id'] = this.pwProjectId;
    data['name'] = this.name;
    data['extension'] = this.extension;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['path'] = this.path;
    data['destination'] = this.destination;
    data['original_path'] = this.originalPath;
    return data;
  }
}
