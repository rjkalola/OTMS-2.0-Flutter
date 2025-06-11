import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/permission_info.dart';

class UserPermissionsResponse {
  bool? isSuccess;
  String? message;
  List<PermissionInfo>? permissions;

  UserPermissionsResponse({this.isSuccess, this.message, this.permissions});

  UserPermissionsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['permissions'] != null) {
      permissions = <PermissionInfo>[];
      json['permissions'].forEach((v) {
        permissions!.add(new PermissionInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.permissions != null) {
      data['permissions'] = this.permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
