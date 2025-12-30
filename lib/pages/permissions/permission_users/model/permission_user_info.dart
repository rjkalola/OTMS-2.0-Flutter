class PermissionUserInfo {
  int? id;
  int? permissionId;
  int? companyId;
  int? status;
  int? userId;
  String? userName;
  String? userImageName;
  String? userImage;
  String? userThumbImage;
  bool? isApp;
  bool? isWeb;

  PermissionUserInfo(
      {this.id,
        this.permissionId,
        this.companyId,
        this.status,
        this.userId,
        this.userName,
        this.userImageName,
        this.userImage,
        this.userThumbImage,
        this.isApp,
        this.isWeb,});

  PermissionUserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    permissionId = json['permission_id'];
    companyId = json['company_id'];
    status = json['status'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImageName = json['user_image_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    isApp = json['is_app'];
    isWeb = json['is_web'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['permission_id'] = this.permissionId;
    data['company_id'] = this.companyId;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_image_name'] = this.userImageName;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['is_app'] = this.isApp;
    data['is_web'] = this.isWeb;
    return data;
  }
}