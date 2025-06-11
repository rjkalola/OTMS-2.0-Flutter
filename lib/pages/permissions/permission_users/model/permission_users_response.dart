import 'package:otm_inventory/pages/permissions/permission_users/model/permission_user_info.dart';

class PermissionUsersResponse {
  bool? isSuccess;
  String? message;
  List<PermissionUserInfo>? info;

  PermissionUsersResponse({this.isSuccess, this.message, this.info});

  PermissionUsersResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <PermissionUserInfo>[];
      json['info'].forEach((v) {
        info!.add(new PermissionUserInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
