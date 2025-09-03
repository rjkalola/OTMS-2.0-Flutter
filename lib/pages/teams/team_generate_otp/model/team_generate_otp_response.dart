import 'package:belcka/pages/teams/team_list/model/team_info.dart';

class TeamGenerateOtpResponse {
  bool? isSuccess;
  String? message;
  GenerateOtpInfo? info;

  TeamGenerateOtpResponse({this.isSuccess, this.message, this.info});

  TeamGenerateOtpResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? GenerateOtpInfo.fromJson(json['info']) : null;
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

class GenerateOtpInfo {
  int? id;
  String? name;
  String? companyOtp;
  String? expiredOn;

  GenerateOtpInfo({this.id, this.name, this.companyOtp, this.expiredOn});

  GenerateOtpInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyOtp = json['company_otp'];
    expiredOn = json['expired_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['company_otp'] = this.companyOtp;
    data['expired_on'] = this.expiredOn;
    return data;
  }
}
