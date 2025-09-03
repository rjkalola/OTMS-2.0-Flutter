import 'package:belcka/pages/company/company_signup/model/company_info.dart';

class CompanyDetailsResponse {
  bool? isSuccess;
  String? message;
  CompanyInfo? info;

  CompanyDetailsResponse({this.isSuccess, this.message, this.info});

  CompanyDetailsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? new CompanyInfo.fromJson(json['info']) : null;
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
