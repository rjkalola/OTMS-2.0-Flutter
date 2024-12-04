import 'package:otm_inventory/pages/otp_verification/model/user_info.dart';

class UserResponse {
  bool? isSuccess;
  String? message;
  UserInfo? info;

  UserResponse({this.isSuccess, this.message, this.info});

  UserResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    info = json['info'] != null ? UserInfo.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}



