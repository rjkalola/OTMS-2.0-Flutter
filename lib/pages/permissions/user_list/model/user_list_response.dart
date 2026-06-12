import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_response_model.dart';

class UserListResponse {
  bool? isSuccess;
  String? message;
  List<UserInfo>? info;
  int? totalUsers;
  int? workingMemberCount;
  PaginationData? pagination;

  UserListResponse({
    this.isSuccess,
    this.message,
    this.info,
    this.totalUsers,
    this.workingMemberCount,
    this.pagination,
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

    print(json);
    print(json['data']);
    print(json['data'].runtimeType);

    pagination = json['data'] != null ? PaginationData.fromJson(json['data']) : null;
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
