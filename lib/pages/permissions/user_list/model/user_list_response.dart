import 'package:belcka/pages/common/model/user_info.dart';

class UserListResponse {
  bool? isSuccess;
  String? message;
  List<UserInfo>? info;
  int? totalUsers;
  int? workingMemberCount;

  UserListResponse({
    this.isSuccess,
    this.message,
    this.info,
    this.totalUsers,
    this.workingMemberCount,
  });

  UserListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    totalUsers = json['total_users'];
    workingMemberCount = json['working_member_count'];
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
    data['total_users'] = this.totalUsers;
    data['working_member_count'] = this.workingMemberCount;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
