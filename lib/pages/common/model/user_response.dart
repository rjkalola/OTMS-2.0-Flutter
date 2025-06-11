import 'package:otm_inventory/pages/common/model/user_info.dart';

class UserResponse {
  bool? isSuccess;
  String? message;
  UserInfo? info;

  UserResponse({this.isSuccess, this.message, this.info});

  UserResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? UserInfo.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}
