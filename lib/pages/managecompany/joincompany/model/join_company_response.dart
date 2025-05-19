import 'package:otm_inventory/pages/common/model/user_info.dart';

class JoinCompanyResponse {
  bool? isSuccess;
  String? message;
  UserInfo? Data;

  JoinCompanyResponse({this.isSuccess, this.message, this.Data});

  JoinCompanyResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    Data = json['Data'] != null ? UserInfo.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    if (this.Data != null) {
      data['Data'] = this.Data!.toJson();
    }
    return data;
  }
}
