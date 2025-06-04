import 'package:otm_inventory/pages/common/model/user_info.dart';

class UserListResponse {
  bool? isSuccess;
  String? message;
  List<UserInfo>? info;

  UserListResponse({this.isSuccess, this.message, this.info});

  UserListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <UserInfo>[];
      json['info'].forEach((v) {
        info!.add(new UserInfo.fromJson(v));
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
